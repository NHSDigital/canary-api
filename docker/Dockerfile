FROM node:13

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN chmod -R a+x /app

EXPOSE 9000
CMD ["npm", "start"]
