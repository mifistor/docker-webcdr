FROM node:8-alpine

LABEL maintainer Pedro Robson Leão <pedro.leao@gmail.com>

ENV APP_HOME=/opt/webcdr-master
ENV ENTRYPOINT=./entrypoint.sh


RUN wget https://github.com/ipoddubny/webcdr/archive/master.zip -O /tmp/webcdr.zip && unzip /tmp/webcdr.zip -d /opt && \
    cd /opt/webcdr-master && \
    apk add --no-cache \
        mysql-client \
        git \
        python3 \
        make && \
    npm -g install \
        bower \
        browserify && \
    cd public/ && \
    bower install --allow-root && \
    cd .. && \
    npm install && \
    npm run build && \
    apk del git python3 make

WORKDIR ${APP_HOME}

ADD ${ENTRYPOINT} ${APP_HOME}/

EXPOSE 9030

CMD chmod 755 ${APP_HOME}/entrypoint.sh

ENTRYPOINT [ "sh","/opt/webcdr-master/entrypoint.sh" ]
