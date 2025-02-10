FROM httpd:2.4

RUN apt-get update && \
    apt-get install -y cpanminus && \
    cpanm CGI && \
    rm -rf /var/lib/apt/lists/*

# Configure Apache
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf

# Copy the CGI script and data file
COPY ./bbs.cgi /usr/local/apache2/cgi-bin/bbs.cgi
COPY ./bbs_data.txt /usr/local/apache2/cgi-bin/bbs_data.txt

EXPOSE 80

CMD ["httpd-foreground"]
