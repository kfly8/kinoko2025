import type { Post } from "./types";

type Props = {
	posts: Post[];
}

export default function PostList({ posts }: Props) {
	return (
		<ul>
			{posts.map((post) => (
				<li key={post.id}>
					<strong>{post.name}</strong>
					<span>{post.timestamp}</span><br />
					{post.comment}
				</li>
			))}
		</ul>
	);
}
