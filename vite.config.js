import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import legacy from '@vitejs/plugin-legacy'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    legacy({
      targets: ['defaults', 'not IE 11'],
    }),
  ],
})
