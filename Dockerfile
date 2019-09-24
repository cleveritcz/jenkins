FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt-get install -y python-pip python-ldap python-yaml nano vim alien libaio1 python3 python3-pip

# Install Oracle client
RUN wget -q -O /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN cd /root && alien -d /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN dpkg -i /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb
RUN rm -f /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm

#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip3 install podman-compose ansible

EXPOSE 389
EXPOSE 1521
EXPOSE 8080
EXPOSE 50000
