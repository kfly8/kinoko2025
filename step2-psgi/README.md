# SETUP

```sh
docker build --pull -t step2 .
docker run -d -p 8882:80 step2
```

```sh
carton install
carton exec -- plackup -Ilib --port 8080 ./bbs.psgi
```
