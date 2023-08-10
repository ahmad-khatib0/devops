FROM node

WORKDIR /app 
# this because we'll host our project in the app folder of the container
# so we wanna till docker to run such commands (eg npm install) inside 
# this app folder, because it run them inside the root folder by default

COPY package.json /app

RUN npm install
# run runs during the build time,so its not correct to say 
# RUN node server.js , instead CMD runs after the image has been built 

# we switched the order, we copied packages and installed them first,and then copied our 
# project files,because of the layering system because we don't often change our dependencies 
# but for the project code files, we do . so we put it after them (COPY . /app) to reduce 
# the amount of the commands after COPY . /app command, in the next build 
# because they will not be cached of course because of the layering system 
COPY . /app
# copy * in this project to /app in the container system file
# COPY . ./ 
# the tow commands are the same, because we've specified WORKDIR above

EXPOSE 80

CMD ["node" , "server.js"] 
# if you don't specify a CMD , the (CMD of the base image) will be excited
# with no base image and no CMD, you'd get an error 
