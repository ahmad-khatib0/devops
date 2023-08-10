FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ARG DEFAULT_PROT=80
# arg can be use on build time instructions, not runtime ie(npm start)

# ENV PORT 80 or:
ENV PORT $DEFAULT_PROT

EXPOSE $PORT

# VOLUME ["/app/feedback"]
# this creates an anonymous volume 

# CMD [ "node", "server.js" ]
CMD [ "npm", "start" ]
# to use nodemon instead to what for changes in js files 