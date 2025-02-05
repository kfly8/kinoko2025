import { css } from 'hono/css'
import { createRoute } from 'honox/factory'
import PostIsland from '../islands/post'
import { useState, useEffect } from 'hono/jsx'
import type { Post } from '../types'

const className = css`
  font-family: sans-serif;
`

export default createRoute((c) => {
	const [posts, setPosts] = useState<Post[]>([]);

	const host = import.meta.env.VITE_HOST as string;

	// 投稿一覧を取得
	useEffect(() => {
		fetch(`${host}/api/post`)
			.then((res) => res.json())
			.then((data) => setPosts(data as Post[]))
			.catch((err) => console.error("Failed to fetch posts", err))
	}, []);

	return c.render(
		<div class={className}>
		  <h1>きのこ掲示板</h1>
		  <PostIsland posts={posts}/>
		</div>,
		{ title: 'きのこ掲示板' }
	)
})
