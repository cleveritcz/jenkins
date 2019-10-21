FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt full-upgrade -y && apt autoremove -y
RUN apt-get install -y python-pip python-ldap python-yaml nano vim alien libaio1 python3 python3-pip heirloom-mailx pwgen dnsutils samba
# Install Oracle client
RUN wget -q -O /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN cd /root && alien -d /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN dpkg -i /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb
RUN rm -f /root/oracle-instantclient19.3-basic_19.3.0.0.0-2_amd64.deb /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm

RUN wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip && unzip packer_1.4.4_linux_amd64.zip && rm -f packer_1.4.4_linux_amd64.zip && mv packer /usr/sbin/packer && chmod u+x /usr/sbin/packer

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

#RUN curl https://bootstrap.pypa.io/get-pip.py|python
# Install app dependencies
RUN pip install --upgrade pip
ADD requirements.txt /opt

RUN pip install -r /opt/requirements.txt
RUN rm -f /opt/requirements.txt
RUN pip3 install ansible ansible-lint

EXPOSE 8080
EXPOSE 50000
