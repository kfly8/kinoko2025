import { useState } from 'hono/jsx'

type Props = {
	addPost: (props: { name: string, comment: string }) => void;
}

export default function PostForm({ addPost }: Props) {
	const [name, setName] = useState("");
	const [comment, setComment] = useState("");

	const handleSubmit = (e: Event) => {
		e.preventDefault();

		if (!comment.trim()) return;
		addPost({ name, comment });
		setName("");
		setComment("");
	};

	return (
		<form onSubmit={(e) => handleSubmit(e)}>
			<label>名前: <input type="text" value={name} onChange={(e) => { if (e.currentTarget instanceof HTMLInputElement) setName(e.currentTarget.value) }} /></label><br/>
			<label>コメント: <textarea value={comment} onChange={(e) => { if (e.currentTarget instanceof HTMLTextAreaElement) setComment(e.currentTarget.value) } } /></label><br/>
			<input type="submit" value="投稿" />
		</form>
	);
}
