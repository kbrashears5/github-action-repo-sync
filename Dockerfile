# https://pkgs.alpinelinux.org/packages
FROM alpine:latest

RUN apk add --no-cache bash

RUN apk add git

# add jq for json parsing
RUN apk add jq

# add curl for github api commands
RUN apk add curl

COPY entrypoint.sh /entrypoint.sh

RUN chmod 777 entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]