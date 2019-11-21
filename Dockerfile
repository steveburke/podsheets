from kkarczmarczyk/node-yarn:8.0 as jsBuilder
USER root
ADD . /src
WORKDIR /src
RUN yarn config set "strict-ssl" false -g
RUN yarn install
RUN yarn build

from node:8-jessie
USER root
COPY --from=jsBuilder /src/server/build /app
# for server side, the build is just translate tsx to js, no packaging, we still need node_module to run.
COPY --from=jsBuilder /src/server/node_modules /app/node_modules
COPY --from=jsBuilder /src/server/src/public /app/public
WORKDIR /app
CMD node ./index.js
