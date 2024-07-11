# syntax=docker/dockerfile:1

ARG VERSION=1.30.2

###
FROM alpine:3.20 AS builder
RUN apk add --no-cache bash file git go make ncurses rsync

ARG VERSION
ARG HOSTOS
ARG HOSTARCH

WORKDIR /app
# https://github.com/kubernetes/kubectl.git
RUN git clone https://github.com/kubernetes/kubernetes.git /app
RUN git checkout -b v${VERSION} v${VERSION}

#
ENV VERSION=${VERSION}
ENV GOOS=${HOSTOS}
ENV GOARCH=${HOSTARCH}

ENV KUBE_BUILD_PLATFORMS=${HOSTOS}/${HOSTARCH}

RUN make kubectl

RUN mkdir /egress && mv _output/local/bin/${HOSTOS}/${HOSTARCH}/kubectl /egress/
#
CMD [ "bash" ]
