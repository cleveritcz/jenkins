FROM rockylinux/rockylinux:9.1-minimal

# Install dependencies
RUN microdnf -y update
RUN microdnf -y install java-11-openjdk wget

# Install Jenkins
RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
RUN microndnf --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
RUN microdnf install jenkins --nobest

# Install Packer
RUN wget https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip && unzip packer_1.8.5_linux_amd64.zip && rm -f packer_1.8.5_linux_amd64.zip && mv packer /usr/sbin/packer && chmod u+x /usr/sbin/packer

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

RUN pip3 install -U pip
# Install app dependencies
ADD requirements.txt /opt

RUN pip3 install -r /opt/requirements.txt
RUN rm -f /opt/requirements.txt

# Install Ansible
RUN pip3 install ansible ansible-lint

EXPOSE 8080
EXPOSE 50000
