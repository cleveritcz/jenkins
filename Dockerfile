FROM rockylinux/rockylinux:9-minimal

ENV JENKINS_VERSION=2.384

RUN echo "Prepping user and group jenkins"
RUN echo -e "jenkins:x:1000:" >> /etc/group
RUN echo -e "jenkins:x:1000:1000:jenkins:/var/jenkins_home:/bin/sh" >> /etc/passwd
RUN echo -e "jenkins:*:19295:0:99999:7:::" >> /etc/shadow

# Install dependencies
RUN microdnf -y update
RUN microdnf -y install java-11-openjdk wget unzip tar python3-pip

# Add init script
COPY src/jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 500 /usr/local/bin/jenkins.sh

# Install Jenkins
RUN mkdir -p /usr/share/jenkins/ref /usr/share/jenkins/ref/plugins /var/jenkins_home
RUN wget -qqO /usr/share/jenkins/jenkins.war https://get.jenkins.io/war/2.384/jenkins.war
RUN chown -R jenkins:jenkins /usr/share/jenkins /var/jenkins_home /usr/local/bin/jenkins.sh
COPY src/jenkins-plugin-cli /bin/jenkins-plugin-cli 
COPY src/plugins.yaml /var/jenkins_home/plugins.yaml
COPY src/jenkins-support /usr/local/bin/jenkins-support
RUN chmod +x /usr/local/bin/jenkins-support

# Download jenkins-plugin-manager
RUN wget -qqO /opt/jenkins-plugin-manager.jar https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.9/jenkins-plugin-manager-2.12.9.jar

# Download plugins
RUN java -jar /opt/jenkins-plugin-manager.jar --war /usr/share/jenkins/jenkins.war -f /var/jenkins_home/plugins.yaml -d /usr/share/jenkins/ref/plugins

# Install Docker
COPY src/docker-ce.repo /etc/yum.repos.d/docker-ce.repo
RUN microdnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN usermod -aG docker jenkins

# Install Packer
RUN wget -qq https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip && unzip packer_1.8.5_linux_amd64.zip && rm -f packer_1.8.5_linux_amd64.zip && mv packer /usr/sbin/packer && chmod +x /usr/sbin/packer

# Upgrade pip3
RUN pip3 install -U pip

# Install Ansible
RUN pip3 install ansible ansible-lint

# Change timezone
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

USER jenkins

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV JENKINS_VERSION=2.384
ENV REF=/usr/share/jenkins/ref
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log
ENV JENKINS_UC=https://updates.jenkins.io

EXPOSE 8080
EXPOSE 50000

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
