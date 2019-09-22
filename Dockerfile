FROM alpine:3.10

RUN apk add --no-cache busybox-extras bash figlet util-linux git tzdata

RUN mkdir /code

COPY create-banner.sh /

ENTRYPOINT ["/create-banner.sh"]

