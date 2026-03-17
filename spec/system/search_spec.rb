# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Searching', :js do
  it 'can search for a result that is highlighted' do
    visit "/"
    fill_in 'q', with: "concrete sumo"
    find_by_id('search-box').native.send_keys(:return)

    using_wait_time 60 do
      expect(page).to have_text('The concrete sumo')
    end
  end
end
