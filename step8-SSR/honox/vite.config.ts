import build from '@hono/vite-build/bun'
import honox from 'honox/vite'
import { viteMockServe } from "vite-plugin-mock";
import { defineConfig } from 'vite'
import type { UserConfig } from "vite";

export default defineConfig(({ mode }) => {
	let config: UserConfig;
	if (mode === "client") {
		config = {
			build: {
				rollupOptions: {
					input: {
						client: "./app/client.ts",
					},
					output: {
						dir: "./dist",
						entryFileNames: "assets/[name].js",
						assetFileNames: "assets/[name].[ext]",
					},
				},
				copyPublicDir: false,
				minify: true,
			},
		};
	} else {
		config = {
			plugins: [
				honox(),
				build({
					minify: false,
				}),
				viteMockServe(),
			],
		};
	}
	return config;
});
