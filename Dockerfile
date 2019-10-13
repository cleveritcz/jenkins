FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt full-upgrade -y
RUN apt-get install -y python-pip python-ldap python-yaml nano vim alien libaio1 python3 python3-pip bsd-mailx pwgen dnsutils samba-tool

# Install Oracle client
RUN wget -q -O /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN cd /root && alien -d /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN dpkg -i /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb
RUN rm -f /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm

#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
ADD requirements.txt /opt

RUN pip install -r /opt/requirements.txt
RUN rm -f /opt/requirements.txt
RUN pip3 install ansible

EXPOSE 8080
EXPOSE 50000
