FROM phusion/baseimage:0.9.16
MAINTAINER jefeweisen@users.noreply.github.com

# JVM:
RUN \
  apt-get update && \
  apt-get install -y openjdk-7-jre && \
  rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64


# JVM code:
ADD dockerpipeline.jar /var/lib/dockerpipeline.jar

# ExternalProcess scripts, etc:
ADD dockerpipeline /lib/dockerpipeline
