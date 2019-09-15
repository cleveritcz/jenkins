FROM jenkins:latest
USER root
RUN apt-get update
RUN apt-get install -y python-pip
# Install app dependencies
# RUN pip install --upgrade pip
