# SETUP

```sh
docker build --pull -t step3 .
docker run -d -p 8883:8080 step3
```

```sh
carton install
carton exec -- morbo ./bbs.psgi
```
