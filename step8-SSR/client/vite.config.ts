import build from '@hono/vite-build'
import honox from 'honox/vite'
import { viteMockServe } from "vite-plugin-mock";
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [honox(), build({}), viteMockServe()]
})
