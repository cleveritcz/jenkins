FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-pip
#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
RUN pip install cx_Oracle pysphere python-ldap

EXPOSE 80
EXPOSE 50000
