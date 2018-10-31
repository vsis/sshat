FROM ubuntu:latest
MAINTAINER Roddy González <roddy.gonzalez.89@gmail.com>

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y tmux openssh-server locales locales-all
RUN mkdir /run/sshd

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

EXPOSE 22

ADD ./talk.sh /talk.sh
ADD ./tmux.conf /tmux.conf
ADD ./motd /motd
