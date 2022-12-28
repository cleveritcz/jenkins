FROM rockylinux/rockylinux:9.1-minimal

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV JENKINS_VERSION=2.375.1
ENV REF=/usr/share/jenkins/ref

# Install dependencies
RUN microdnf -y update
RUN microdnf -y install java-11-openjdk wget unzip python3-pip

# Install Jenkins
RUN mkdir -p /usr/share/jenkins/ /var/jenkins_home
RUN wget -qqO /usr/share/jenkins/jenkins.war https://get.jenkins.io/war-stable/2.375.1/jenkins.war

# Add bash script
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins.sh

# Install Packer
RUN wget -qq https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip && unzip packer_1.8.5_linux_amd64.zip && rm -f packer_1.8.5_linux_amd64.zip && mv packer /usr/sbin/packer && chmod u+x /usr/sbin/packer

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

# Upgrade pip3
RUN pip3 install -U pip

# Install Ansible
RUN pip3 install ansible ansible-lint

EXPOSE 8080
EXPOSE 50000
