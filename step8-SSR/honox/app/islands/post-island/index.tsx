import { useState } from 'hono/jsx'

import PostForm from './post-form';
import PostList from './post-list'

import type { paths } from "../../openapi.d"
import createClient from "openapi-fetch";

const client = createClient<paths>();

import type { Post } from '../../types'

type Props = {
	posts: Post[];
}

export default function PostIsland({posts: initialPosts }: Props) {
	const [posts, setPosts] = useState<Post[]>(initialPosts);

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
			<PostForm addPost={addPost} />
			<PostList posts={posts} />
		</>
	)
}
