FROM node:8

RUN apt-get update && \
    apt-get install -y mysql-client-5.5 curl unzip && \
    apt-get clean

RUN curl -sf \
        -o /tmp/webcdr.zip \
        -L https://github.com/ipoddubny/webcdr/archive/master.zip && \
    unzip /tmp/webcdr/zip && \
    cd /tmp/webcdr-master
	
WORKDIR /tmp/webcdr-master

RUN npm -g install bower browserify && cd /tmp/webcdr-master/public && \
	bower install --allow-root && cd .. && \
    npm install && \
    npm run build

CMD node /tmp/webcdr-master/server.js
