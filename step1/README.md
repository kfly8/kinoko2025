# SETUP

```sh
docker build --pull -t step1 .
docker run -d -p 8880:80 step1
```

http://localhost:8880/cgi-bin/bbs.pl
