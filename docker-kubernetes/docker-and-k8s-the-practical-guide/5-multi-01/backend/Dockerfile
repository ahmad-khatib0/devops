FROM node:14-alpine 

WORKDIR /app 

COPY package.json .

RUN npm install 

COPY . . 

EXPOSE 80

ENV MONGODB_USERNAME=ahmad
ENV MONGODB_PASSWORD=12345678

CMD ["node" , "app.js"]