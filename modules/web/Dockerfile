FROM node:argon

WORKDIR /usr/microserv/web
ADD package.json package.json
ADD . /usr/microserv/web
RUN npm i -g coffee-script nodemon
RUN npm i
