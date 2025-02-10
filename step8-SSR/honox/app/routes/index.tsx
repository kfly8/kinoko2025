import { css } from 'hono/css'
import { createRoute } from 'honox/factory'
import PostIsland from '../islands/post-island'

import type { paths } from "../openapi.d"
import createClient from "openapi-fetch";

const client = createClient<paths>({ baseUrl: import.meta.env.VITE_HOST! });

const className = css`
  font-family: sans-serif;
`

export default createRoute(async (c) => {
	const { data, error } = await client.GET('/api/post');

	if (error) {
		throw new Error(`Failed to fetch posts. ${error}`);
	}

	return c.render(
		<div class={className}>
			<h1>きのこ掲示板</h1>
			<PostIsland posts={data}/>
		</div>,
		{ title: 'きのこ掲示板' }
	)
})
