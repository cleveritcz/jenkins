FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt-get install -y python-pip python-ldap python-yaml nano vim alien libaio1

# Install Oracle client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN alien -r --scripts oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN ls -l
RUN dpkg -i oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.deb
RUN apt -f install

#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
RUN pip install cx_Oracle pysphere python-ldap

EXPOSE 389
EXPOSE 1521
EXPOSE 8080
EXPOSE 50000
