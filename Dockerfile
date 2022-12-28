FROM cleveritcz/python:3.11-rocky-linux-9

ENV PATH="/app/python3.11/bin:$PATH"
ENV JENKINS_VERSION=2.375.1

RUN echo "Prepping user and group jenkins"
RUN echo -e "jenkins:x:1000:" >> /etc/group
RUN echo -e "jenkins:x:1000:1000:jenkins:/var/jenkins_home:/bin/sh" >> /etc/passwd
RUN echo -e "jenkins:*:19295:0:99999:7:::" >> /etc/shadow

# Install dependencies
RUN microdnf -y update
RUN microdnf -y install java-11-openjdk wget unzip tar

# Install Jenkins
RUN mkdir -p /usr/share/jenkins/ref /var/jenkins_home
RUN wget -qqO /usr/share/jenkins/jenkins.war https://get.jenkins.io/war-stable/2.375.1/jenkins.war
RUN chown -R jenkins:jenkins /usr/share/jenkins /var/jenkins_home

# Add bash script
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins.sh

# Install Packer
RUN wget -qq https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip && unzip packer_1.8.5_linux_amd64.zip && rm -f packer_1.8.5_linux_amd64.zip && mv packer /usr/sbin/packer && chmod +x /usr/sbin/packer

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

USER jenkins

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV JENKINS_VERSION=2.375.1
ENV REF=/usr/share/jenkins/ref
ENV PATH="/app/python3.11/bin:$PATH"

# Upgrade pip3
RUN /app/python3.11/bin/pip3 install -U pip

# Install Ansible
RUN /app/python3.11/bin/pip3 install ansible ansible-lint

EXPOSE 8080
EXPOSE 50000

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
