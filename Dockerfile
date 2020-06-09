FROM node:8-alpine

LABEL maintainer Pedro Robson Leão <pedro.leao@gmail.com>

RUN wget https://github.com/ipoddubny/webcdr/archive/master.zip -O /tmp/webcdr.zip && unzip /tmp/webcdr.zip -d /opt

ENV APP_HOME=/opt/webcdr-master
ENV ENTRYPOINT=./entrypoint.sh

WORKDIR ${APP_HOME}

RUN apk add --no-cache \
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
    npm run build

ADD ${ENTRYPOINT} ${APP_HOME}/

EXPOSE 9030

CMD chmod 755 ${APP_HOME}/entrypoint.sh

ENTRYPOINT [ "sh","/opt/webcdr-master/entrypoint.sh" ]
