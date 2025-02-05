FROM oven/bun:1 AS client-dist-builder

WORKDIR /app

COPY ./client/package.json ./client/bun.lock ./
RUN bun install --frozen-lockfile

COPY ./client/ .

ENV NODE_ENV=production
RUN bun run build

FROM nginx:latest

COPY --from=client-dist-builder /app/dist /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
