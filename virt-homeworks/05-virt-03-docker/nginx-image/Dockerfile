# Download base image ubuntu 22.04
FROM ubuntu:22.04

# LABEL about the custom image
LABEL maintainer="Aleksey Raevich <raevich.ap@yandex.ru>"
LABEL version="1.0"
LABEL description="This is a custom Docker Image"

ENV TZ=Europe/Moscow

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Define the ENV variable
ENV nginx_conf /etc/nginx/nginx.conf

# Copy start.sh script and define default command for the container
COPY index.html /usr/share/nginx/html

# Expose Port
EXPOSE 80 443