ARG VARIANT=16-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

RUN apt-get update && apt-get install libtinfo5 -y

RUN curl https://static.lamdera.com/bin/linux/lamdera -o /usr/local/bin/lamdera && chmod a+x /usr/local/bin/lamdera

RUN npm install --global elm-format elm-review elm-spa elm-test