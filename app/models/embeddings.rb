# frozen_string_literal: true

# Semantic vectors for posts and bookmarks, generated on-device with the open
# all-MiniLM-L6-v2 sentence-transformer model (via the informers gem / ONNX).
# The model (~90MB) is downloaded once from Hugging Face into ~/.cache/informers,
# and only loaded when something needs embedding.
#
# Each document stores its vector in its own front matter, under one key:
#
#   embedding:
#     model: "<model>@<revision>:v<format>"
#     digest: "<hash of the embedded text>"
#     vector: "<base64 int8>"
#
# `rake embeddings:update` only re-embeds documents whose text, model, revision
# or format changed. Text is split into token windows (the model was trained on
# at most 256 tokens) and the document vector is the normalized mean of the
# window vectors, quantized to int8.
class Embeddings
  KEY = "embedding"
  MODEL = "sentence-transformers/all-MiniLM-L6-v2"
  REVISION = "1110a243fdf4706b3f48f1d95db1a4f5529b4d41" # pinned Hugging Face commit
  # Bump when chunking/pooling/quantization changes, to force a full re-embed.
  FORMAT_VERSION = 3
  DIMENSIONS = 384
  WINDOW_TOKENS = 254 # trained max_seq_length (256) minus [CLS] and [SEP]
  # Identifies everything that affects the vectors: model, pinned revision, format.
  MODEL_ID = "#{MODEL}@#{REVISION.first(8)}:v#{FORMAT_VERSION}".freeze
  FRONT_MATTER = /\A(---\s*\n)(.*?\n)?(---\s*$)/m

  def self.digest_for(text)
    Digest::SHA256.hexdigest(text).first(16)
  end

  # Decoded int8 bytes for a record's stored vector, or nil if missing, invalid,
  # or produced by a different model/revision/format.
  def self.stored_vector(record)
    entry = record.frontmatter[KEY]
    return unless entry.is_a?(Hash)
    return unless entry["model"] == MODEL_ID

    bytes = entry["vector"].to_s.unpack1("m0")
    bytes if bytes.bytesize == DIMENSIONS
  rescue ArgumentError
    nil
  end

  # Re-embeds records whose stored embedding is missing or stale, rewriting
  # only the `embedding:` block of each file. Returns the number re-embedded.
  def self.update!(records)
    stale = records.filter_map do |record|
      text = record.embedding_text.squish
      digest = digest_for(text)
      next if record.frontmatter.dig(KEY, "digest") == digest && stored_vector(record)

      [record, text, digest]
    end
    return 0 if stale.empty?

    embedder = Embedder.new
    stale.each do |record, text, digest|
      quantized = embedder.call(text).map { |f| (f * 127).round.clamp(-127, 127) }
      write_entry(record.filepath, digest: digest, vector: [quantized.pack("c*")].pack("m0"))
    end
    stale.size
  end

  # Replaces (or appends) the `embedding:` block in a file's front matter as
  # text, leaving every other byte of the file untouched.
  def self.write_entry(path, digest:, vector:)
    source = File.read(path)
    match = FRONT_MATTER.match(source) or raise "No front matter in #{path}"

    yaml = match[2].to_s.gsub(/^#{KEY}:.*\n(?:[ \t]+.*\n)*/o, "")
    block = <<~YAML
      #{KEY}:
        model: #{MODEL_ID.to_json}
        digest: #{digest.to_json}
        vector: #{vector.to_json}
    YAML
    File.write(path, "#{match[1]}#{yaml}#{block}#{match[3]}#{match.post_match}")
  end

  def initialize(records)
    @records = records.select { |record| self.class.stored_vector(record) }
    @row_index = @records.each_with_index.to_h { |record, i| [record.project_filepath, i] }
  end

  # The `limit` indexed records most similar to `record`, most similar first.
  # Nil if `record` isn't indexed.
  def most_similar(record, limit:)
    row = @row_index[record.project_filepath]
    return unless row

    scores = matrix.dot(matrix[row, true])
    scores.sort_index.to_a.reverse_each.lazy
          .map { |i| @records[i] }
          .reject { |candidate| candidate.project_filepath == record.project_filepath }
          .first(limit)
  end

  private

  # All vectors stacked into one matrix, rows re-normalized after quantization
  # so dot products are cosine similarities.
  def matrix
    @_matrix ||= begin
      m = Numo::Int8.from_binary(@records.map { |record| self.class.stored_vector(record) }.join)
                    .reshape(@records.size, DIMENSIONS).cast_to(Numo::SFloat)
      norms = Numo::NMath.sqrt((m**2).sum(axis: 1))
      norms[norms.eq(0)] = 1
      m / norms.expand_dims(1)
    end
  end

  # Wraps the model and tokenizer; loaded lazily since it's ~90MB.
  class Embedder
    def initialize
      require "informers"
      @model = Informers.pipeline("embedding", MODEL, revision: REVISION)
      @tokenizer = Tokenizers::Tokenizer.from_file(Informers::Utils::Hub.get_model_file(MODEL, "tokenizer.json", true, revision: REVISION))
      @tokenizer.no_truncation
      @tokenizer.no_padding
    end

    # Normalized mean of the text's token-window vectors.
    def call(text)
      sum = @model.call(windows(text)).transpose.map(&:sum)
      norm = Math.sqrt(sum.sum { |x| x * x })
      sum.map { |x| norm.zero? ? x : x / norm }
    end

    private

    def windows(text)
      offsets = @tokenizer.encode(text, add_special_tokens: false).offsets
      return [text] if offsets.empty?

      offsets.each_slice(WINDOW_TOKENS).map { |slice| text[slice.first[0]...slice.last[1]] }
    end
  end
end
