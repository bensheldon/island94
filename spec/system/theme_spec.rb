# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Bootstrap color mode theme', :js do
  let(:toggle) { 'button[data-controller="theme"]' }

  it 'defaults to auto, toggles an override, and returns to auto when toggled back' do
    visit "/"

    # Auto with no stored theme; test env has no OS dark preference, so light.
    expect(page).to have_css 'html[data-bs-theme="light"]'
    expect(page).to have_css "#{toggle} .bi-moon-stars-fill"
    expect(page).to have_css "#{toggle}[aria-label='Switch to dark theme (currently auto, light)']"
    expect(page.evaluate_script("localStorage.getItem('theme')")).to be_nil

    # Override to dark
    find(toggle).click
    expect(page).to have_css 'html[data-bs-theme="dark"]'
    expect(page).to have_css "#{toggle} .bi-sun"
    expect(page).to have_css "#{toggle}[aria-label='Switch to light theme (currently dark)']"
    expect(page.evaluate_script("localStorage.getItem('theme')")).to eq "dark"

    # Persists across reload
    visit "/"
    expect(page).to have_css 'html[data-bs-theme="dark"]'
    expect(page).to have_css "#{toggle} .bi-sun"

    # Toggling back to the OS theme clears the override (auto)
    find(toggle).click
    expect(page).to have_css 'html[data-bs-theme="light"]'
    expect(page).to have_css "#{toggle}[aria-label='Switch to dark theme (currently auto, light)']"
    expect(page.evaluate_script("localStorage.getItem('theme')")).to be_nil

    visit "/"
    expect(page).to have_css 'html[data-bs-theme="light"]'
    expect(page).to have_css "#{toggle} .bi-moon-stars-fill"
  end
end
