import { Controller } from "@hotwired/stimulus"

// Single-button theme toggle.
// Default is "auto" (follows the OS preference). Clicking overrides to the
// opposite of the current theme; clicking back to the OS theme returns to auto.
export default class extends Controller {
  static targets = ["icon", "label"]

  connect() {
    this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
    this.onSystemChange = () => this.#apply()
    this.mediaQuery.addEventListener('change', this.onSystemChange)
    this.#apply()
  }

  disconnect() {
    this.mediaQuery.removeEventListener('change', this.onSystemChange)
  }

  toggle() {
    const next = this.#currentTheme() === 'dark' ? 'light' : 'dark'
    if (next === this.#systemTheme()) {
      localStorage.removeItem('theme')
    } else {
      localStorage.setItem('theme', next)
    }
    this.#apply()
  }

  #systemTheme() {
    return this.mediaQuery.matches ? 'dark' : 'light'
  }

  #storedTheme() {
    const theme = localStorage.getItem('theme')
    return ['light', 'dark'].includes(theme) ? theme : null
  }

  #currentTheme() {
    return this.#storedTheme() || this.#systemTheme()
  }

  #apply() {
    const theme = this.#currentTheme()
    document.documentElement.setAttribute('data-bs-theme', theme)

    const next = theme === 'dark' ? 'light' : 'dark'
    const mode = this.#storedTheme() ? theme : `auto, ${theme}`
    const label = `Switch to ${next} theme (currently ${mode})`
    this.element.setAttribute('aria-label', label)
    this.element.setAttribute('title', label)
    if (this.hasIconTarget) {
      this.iconTarget.className = theme === 'dark' ? 'bi bi-sun' : 'bi bi-moon-stars-fill'
    }
  }
}
