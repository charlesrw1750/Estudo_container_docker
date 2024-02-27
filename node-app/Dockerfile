FROM node:alpine
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
RUN npm install express
COPY ./ ./
CMD ["npm", "start"]
