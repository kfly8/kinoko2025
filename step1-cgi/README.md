# SETUP

```sh
docker build --pull -t step1 .
docker run -d -p 8881:80 step1
```

http://localhost:8881/cgi-bin/bbs.cgi
