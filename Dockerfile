FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt-get install -y python-pip python-ldap python-yaml nano vim
#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
RUN pip install cx_Oracle pysphere python-ldap

EXPOSE 389
EXPOSE 1521
EXPOSE 8080
EXPOSE 50000
