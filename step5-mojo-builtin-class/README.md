# SETUP

```sh
docker build --pull -t step5 .
docker run -d -p 8885:8080 --env-file .env step5
```

