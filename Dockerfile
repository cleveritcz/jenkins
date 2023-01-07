FROM rockylinux/rockylinux:9-minimal

ENV JENKINS_VERSION=2.375.1
ENV PLUGIN_MANAGER_VERSION=2.12.9
ENV PACKER_VERSION=1.8.5

RUN echo -e "jenkins:x:1000:" >> /etc/group && \
    echo -e "jenkins:x:1000:1000:jenkins:/var/jenkins_home:/bin/sh" >> /etc/passwd && \  
    echo -e "jenkins:*:19295:0:99999:7:::" >> /etc/shadow && \
    microdnf -y update && microdnf -y install java-11-openjdk wget unzip tar git python3-pip && \
    mkdir -p /usr/share/jenkins/ref /usr/share/jenkins/ref/plugins /var/jenkins_home && \
    wget -qqO /usr/share/jenkins/jenkins.war https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war && \
    wget -qqO /opt/jenkins-plugin-manager.jar https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/$PLUGIN_MANAGER_VERSION/jenkins-plugin-manager-$PLUGIN_MANAGER_VERSION.jar && \
    wget -qq https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_$PACKER_VERSION_linux_amd64.zip && unzip packer_$PACKER_VERSION_linux_amd64.zip && rm -f packer_$PACKER_VERSION_linux_amd64.zip && \ 
    mv packer /usr/sbin/packer && chmod +x /usr/sbin/packer && \
    pip3 install -U pip && pip3 install ansible ansible-lint && \
    rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

COPY src/jenkins-plugin-cli /bin/jenkins-plugin-cli 
COPY src/plugins.yaml /var/jenkins_home/plugins.yaml
COPY src/jenkins-support /usr/local/bin/jenkins-support
COPY src/jenkins.sh /usr/local/bin/jenkins.sh
RUN chown -R jenkins:jenkins /usr/share/jenkins /var/jenkins_home /usr/local/bin/jenkins.sh && \
    chmod 500 /usr/local/bin/jenkins.sh && chmod +x /usr/local/bin/jenkins-support && \
    java -jar /opt/jenkins-plugin-manager.jar --war /usr/share/jenkins/jenkins.war -f /var/jenkins_home/plugins.yaml -d /usr/share/jenkins/ref/plugins

USER jenkins

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV REF=/usr/share/jenkins/ref
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log
ENV JENKINS_UC=https://updates.jenkins.io

EXPOSE 8080
EXPOSE 50000

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
