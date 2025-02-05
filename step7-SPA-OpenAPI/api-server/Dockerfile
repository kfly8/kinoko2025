FROM perl:5.40

WORKDIR /usr/src/app

COPY cpanfile ./
RUN cpm install --show-build-log-on-failure --without-test

ENV PERL5LIB=/usr/src/app/local/lib/perl5

COPY .env ./
COPY bbs.psgi ./
COPY ./lib ./lib

EXPOSE 8080
CMD ["./local/bin/morbo", "-l", "http://*:8080", "bbs.psgi"]
