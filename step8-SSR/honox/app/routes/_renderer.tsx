import { Style } from 'hono/css'
import { jsxRenderer } from 'hono/jsx-renderer'
import { Script } from 'honox/server'

export default jsxRenderer(({ children, title }) => {
	return (
		<html lang="ja">
		<head>
			<meta charset="UTF-8" />
			<meta name="viewport" content="width=device-width, initial-scale=1.0" />
			<title>{title}</title>
			<link rel="icon" href="/favicon.ico" />
			{import.meta.env.PROD ? (
				<script type="module" src="/assets/client.js" />
			) : (
				<Script src="/app/client.ts" async />
			)}
			<Style />
		</head>
		<body>{children}</body>
		</html>
	);
});
