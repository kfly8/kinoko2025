import build from '@hono/vite-build'
import honox from 'honox/vite'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [honox(), build({})]
})
