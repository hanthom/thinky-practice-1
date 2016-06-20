FROM node:argon

WORKDIR /usr/microserv/db
ADD . /usr/microserv/db
ADD package.json package.json
RUN npm i -g coffee-script
RUN npm i
EXPOSE 10101
