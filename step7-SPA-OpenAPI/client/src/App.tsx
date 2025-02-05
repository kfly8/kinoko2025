import { useState, useEffect } from 'react'

import PostForm from './PostForm'
import PostList from './PostList'

import type { Post } from './types'

function App() {
	const [posts, setPosts] = useState<Post[]>([]);

	// 投稿一覧を取得
	useEffect(() => {
		fetch("/api/post")
			.then((res) => res.json())
			.then((data) => setPosts(data))
			.catch((err) => console.error("Failed to fetch posts", err))
	}, []);

	// 新しい投稿を追加
	const addPost = async (data: { name: string, comment: string }) => {
		const response = await fetch("/api/post", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(data),
		});

		if (response.ok) {
			const newPost = await response.json();
			setPosts([newPost, ...posts]); // 新しい投稿をリストに追加
		} else {
			console.error("Failed to add post");
		}
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
