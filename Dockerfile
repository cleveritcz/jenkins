FROM jenkins:latest
USER root
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-pip
# Install app dependencies
RUN pip install --upgrade pip
RUN pip install cx_Oracle
