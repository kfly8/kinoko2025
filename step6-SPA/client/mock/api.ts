import { MockMethod } from "vite-plugin-mock";

let posts = [
	{
		id: 1,
		name: "名無し",
		comment: "こんにちは",
		timestamp: "2025-02-05 01:25:25",
	},
	{
		id: 2,
		name: "きのこ",
		comment: "Hello",
		timestamp: "2025-02-05 01:25:17",
	},
];

const formatDate = (date: Date): string => {
	return date.toISOString().replace("T", " ").slice(0, 19);
};

export default [
	// GET /api/post - 投稿一覧
	{
		url: "/api/post",
		method: "get",
		response: () => {
			return posts
		},
	},

	// POST /api/post - 新規投稿
	{
		url: "/api/post",
		method: "post",
		response: ({ body }) => {
			const newPost = {
				id: posts.length + 1,
				name: body.name || "名無し",
				comment: body.comment,
				timestamp: formatDate( new Date() ),
			};
			posts.unshift(newPost);
			return newPost
		},
	},
] as MockMethod[];
