# frozen_string_literal: true

# Typed, validatable wrapper around a markdown file's YAML front matter.
#
# Subclasses declare known keys with `attribute`. Unknown keys are kept in
# `extras` so files round-trip without losing data.
class BaseFrontmatter
  include ActiveModel::Model
  include ActiveModel::Attributes

  # ActiveModel type so models can declare `attribute :frontmatter, PostFrontmatter.type`
  # and assign either a Hash or a frontmatter instance.
  class Type < ActiveModel::Type::Value
    def initialize(klass)
      @klass = klass
      super()
    end

    def cast(value)
      case value
      when @klass then value
      when nil then @klass.new
      when Hash then @klass.new(value)
      else raise ArgumentError, "Cannot cast #{value.class} to #{@klass}"
      end
    end
  end

  def self.type
    Type.new(self)
  end

  # Deserializes a YAML front matter string (without the `---` fences).
  def self.from_yaml(yaml)
    new(YAML.safe_load(yaml.to_s) || {})
  end

  attr_reader :extras

  def initialize(attributes = {})
    attributes = (attributes || {}).to_h.stringify_keys
    known, @extras = attributes.partition { |key, _| self.class.attribute_names.include?(key) }.map(&:to_h)
    super(known)
  end

  # Hash-style access to any key, known or extra.
  def [](key)
    key = key.to_s
    self.class.attribute_names.include?(key) ? public_send(key) : extras[key]
  end

  # Known attributes (in declared order, nils omitted) followed by extras.
  def to_h
    attributes.compact.merge(extras)
  end

  # Serializes to a YAML document, starting with the opening `---` fence.
  delegate :to_yaml, to: :to_h

  def ==(other)
    other.class == self.class && other.to_h == to_h
  end
end
