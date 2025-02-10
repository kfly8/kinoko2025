import { useState, useEffect } from 'react'

import PostForm from './PostForm'
import PostList from './PostList'

import type { Post } from './types'

import type { paths } from "./openapi.d";
import createClient from "openapi-fetch";

const client = createClient<paths>();

function App() {
	const [posts, setPosts] = useState<Post[]>([]);

	// 投稿一覧を取得
	useEffect(() => {
		client.GET("/api/post").then(({ data, error }) => {
			if (error) {
				console.error(error);
				return;
			}
			setPosts(data);
		});
	}, []);

	// 新しい投稿を追加
	const addPost = async (body: { name: string, comment: string }) => {
		const { data, error } = await client.POST("/api/post", { body });
		if (error) {
			console.error(error);
			return;
		}
		setPosts([data, ...posts]);
	};

	return (
		<>
			<h1>きのこ掲示板</h1>
			<PostForm addPost={addPost} />
			<PostList posts={posts} />
		</>
	)
}

export default App
