FROM jenkins/jenkins
USER root
RUN apt-get update
RUN apt full-upgrade -y && apt autoremove -y
RUN apt-get install -y python3-pip python3-ldap python3-yaml nano vim alien libaio1 pwgen dnsutils samba python3-magic
# Install Oracle client
RUN wget -q -O /root/oracle-instantclient-basic-21.8.0.0.0-1.el8.x86_64.rpm https://download.oracle.com/otn_software/linux/instantclient/218000/oracle-instantclient-basic-21.8.0.0.0-1.el8.x86_64.rpm
RUN cd /root && alien -d /root/oracle-instantclient-basic-21.8.0.0.0-1.el8.x86_64.rpm
RUN dpkg -i /root/oracle-instantclient-basic-21.8.0.0.0-1_amd64.deb
RUN rm -f /root/oracle-instantclient-basic-21.8.0.0.0-1_amd64.deb /root/oracle-instantclient-basic-21.8.0.0.0-1.el8.x86_64.rpm

RUN wget https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip && unzip packer_1.8.5_linux_amd64.zip && rm -f packer_1.8.5_linux_amd64.zip && mv packer /usr/sbin/packer && chmod u+x /usr/sbin/packer

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

# Install app dependencies
RUN pip3 install -U pip==9.0.2
ADD requirements.txt /opt

RUN pip3 install -r /opt/requirements.txt
RUN rm -f /opt/requirements.txt
RUN pip3 install ansible ansible-lint

EXPOSE 8080
EXPOSE 50000
