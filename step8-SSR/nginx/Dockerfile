FROM oven/bun:1 AS honox-assets

WORKDIR /app

COPY ./honox/package.json ./honox/bun.lock ./
RUN bun install --frozen-lockfile

COPY ./honox/ .

ENV NODE_ENV=production
RUN bun run build:client

FROM nginx:latest

COPY --from=honox-assets /app/dist/assets/ /usr/share/nginx/html/assets/
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
