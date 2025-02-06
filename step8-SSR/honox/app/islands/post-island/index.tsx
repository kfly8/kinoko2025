import { useState } from 'hono/jsx'

import PostForm from './post-form';
import PostList from './post-list'

import type { Post } from '../../types'

type Props = {
	posts: Post[];
}

export default function PostIsland({posts: initialPosts }: Props) {
	const [posts, setPosts] = useState<Post[]>(initialPosts);

	const addPost = async (data: { name: string, comment: string }) => {
		const res = await fetch('/api/post', {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(data),
		});

		if (res.ok) {
			const newPost : Post = await res.json()
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
