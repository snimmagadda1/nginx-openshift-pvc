FROM nginx:mainline

ADD nginx.conf /etc/nginx/

ADD mime.types /etc/nginx/

ADD index.html /var/www/static/index.html


WORKDIR /usr/src

# support running as arbitrary user which belogs to the root group
RUN chmod -R g+rwx /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html /var/www/static

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf


# Prepare for Entrypoint
COPY entrypoint.sh /usr/src/entrypoint.sh
RUN chmod g+rwx /usr/src/entrypoint.sh

RUN addgroup nginx root
USER nginx

ENTRYPOINT "/usr/src/entrypoint.sh"