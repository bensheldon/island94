# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'SEO' do
  context 'when on frontpage' do
    it 'does not include robots meta tag' do
      visit '/'
      expect(page).to have_text("Island94")
      expect(page).to have_no_css 'meta[name="robots"]', visible: :all
    end
  end

  context 'when on a post' do
    it 'does not include robots meta tag' do
      visit '/'
      within(:css, 'h1.post-title', match: :first) do
        click_link
      end

      expect(page.text).to include 'Island94.org'
      expect(page).to have_no_css 'meta[name="robots"]', visible: :all
    end
  end

  context 'when on archive page' do
    it 'includes robots noindex,nofollow meta tag' do
      visit '/posts/2/'

      expect(page).to have_css 'meta[name="robots"][content="noindex, follow"]', visible: :all
    end
  end

  describe 'sitemap' do
    it 'does not include archive pages' do
      visit 'sitemap.xml'

      sitemap = Nokogiri::XML page.body
      urls = sitemap.css('url loc').map(&:text)
      archive_urls = urls.grep(%r{/page/})

      expect(archive_urls).to be_empty
    end
  end
end
