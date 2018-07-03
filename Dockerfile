FROM node:8

RUN apt-get update && \
    apt-get install -y mysql-client-5.5 curl unzip && \
    apt-get clean

RUN wget https://github.com/ipoddubny/webcdr/archive/master.zip -O /tmp/webcdr.zip && unzip /tmp/webcdr.zip -d /tmp
	
WORKDIR /tmp/webcdr-master

RUN npm -g install bower browserify && cd public/ && bower install --allow-root && cd .. && npm install && npm run build

CMD node /tmp/webcdr-master/server.js
