# SETUP

```sh
docker build --pull -t step4 .
docker run -d -p 8883:80 --env-file .env step4
```

