import { css } from 'hono/css'
import { createRoute } from 'honox/factory'
import PostIsland from '../islands/post-island'
import type { Post } from '../types'

const className = css`
  font-family: sans-serif;
`

const fetchPosts = async () => {
	const host = import.meta.env.VITE_HOST!
	const url = host + '/api/post'

	const res = await fetch(url)
	if (!res.ok) {
		throw new Error(`Failed to fetch posts. status: ${res.status}, url: ${url}`);
	}

	const data: Post[] = await res.json();
	return data;
}

export default createRoute(async (c) => {
	const posts = await fetchPosts()

	return c.render(
		<div class={className}>
		  <h1>きのこ掲示板</h1>
		  <PostIsland posts={posts}/>
		</div>,
		{ title: 'きのこ掲示板' }
	)
})
