FROM node:16.18.0

RUN yarn global add @nestjs/cli typescript ts-node

COPY package*.json /tmp/app/
RUN cd /tmp/app && yarn install

COPY . /usr/src/app
RUN cp -a /tmp/app/node_modules /usr/src/app
COPY ./wait-for-it.sh /opt/wait-for-it.sh
COPY ./startup.ci.sh /opt/startup.ci.sh
RUN sed -i 's/\r//g' /opt/wait-for-it.sh
RUN sed -i 's/\r//g' /opt/startup.ci.sh

WORKDIR /usr/src/app
RUN rm -rf .env && cp .env.example .env
RUN yarn build

CMD ["/bin/bash", "/opt/startup.ci.sh"]
