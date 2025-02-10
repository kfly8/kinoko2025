# SETUP

```sh
docker build --pull -t step4 .
docker run -d -p 8884:8080 --env-file .env.production step4
```

