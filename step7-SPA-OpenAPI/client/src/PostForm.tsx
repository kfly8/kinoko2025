import { useState } from 'react'

type Props = {
	addPost: (props: { name: string, comment: string }) => void;
}

export default function PostForm({ addPost }: Props) {
	const [name, setName] = useState("");
	const [comment, setComment] = useState("");

	const handleSubmit = (e: React.FormEvent) => {
		e.preventDefault();

		if (!comment.trim()) return;
		addPost({ name, comment });
		setName("");
		setComment("");
	};

	return (
		<form onSubmit={handleSubmit}>
				<label>名前: <input type="text" value={name} onChange={(e) => setName(e.target.value)} /></label><br/>
				<label>コメント: <textarea value={comment} onChange={(e) => setComment(e.target.value)} /></label><br/>
				<input type="submit" value="投稿" />
		</form>
	);
}
