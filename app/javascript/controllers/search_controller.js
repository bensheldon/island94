import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["results", "input"]

  resultsTargetConnected(_element) {
    const searchQuery = new URLSearchParams(window.location.search).get("q")
    if (!searchQuery) {
      this.resultsTarget.innerHTML = '<p>No search term</p>'
      return
    }

    this.inputTargets.forEach(input => {
      input.value = searchQuery;
    });

    this.#performSearch(searchQuery)
  }

  syncInputs(event) {
    const newValue = event.target.value;
    this.inputTargets.forEach(input => {
      if (input !== event.target) {
        input.value = newValue;
      }
    });
  }

  async #performSearch(searchQuery) {
    const pagefind = await import(/* @vite-ignore */ '/pagefind/pagefind.js')
    const search = await pagefind.search(searchQuery.trim())
    const results = await Promise.all(search.results.map(r => r.data()))
    this.resultsTarget.innerHTML = this.#formatSearchResults(results)
  }

  #formatSearchResults(results) {
    if (results.length) {
      let output = ""
      for (const item of results) {
        output += '<a href="' + item.url + '"><h2>' + item.meta.title + '</h2></a>'
        output += '<p>' + item.excerpt + '</p>'
      }
      return output
    } else {
      return '<p>No results found</p>'
    }
  }
}
