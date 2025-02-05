import { useState } from 'hono/jsx'

import PostForm from './post/post-form'
import PostList from './post/post-list'

import type { Post } from '../types'

type Props = {
	posts: Post[];
}

export default function PostIsland({posts: initialPosts }: Props) {
	const [posts, setPosts] = useState<Post[]>(initialPosts);

	const host = import.meta.env.VITE_HOST as string;

	// 新しい投稿を追加
	const addPost = async (data: { name: string, comment: string }) => {
		console.log('Called addPost');
		console.log(host);

		const response = await fetch(`${host}/api/post`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(data),
		});

		if (response.ok) {
			const newPost = await response.json() as Post;
			setPosts([newPost, ...posts]);
		} else {
			console.error("Failed to add post");
		}
	};

	return (
		<>
			<PostForm addPost={addPost} />
			<PostList posts={posts} />
		</>
	)
}
