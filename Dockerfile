FROM rockylinux/rockylinux:9-minimal as base
# Builder
FROM base as builder

ENV JENKINS_VERSION=2.385
ENV PLUGIN_MANAGER_VERSION=2.12.9

RUN curl -o /usr/share/jenkins/jenkins.war -fsSL https://get.jenkins.io/war/$JENKINS_VERSION/jenkins.war && \
    curl -o /opt/jenkins-plugin-manager.jar -fsSL https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/$PLUGIN_MANAGER_VERSION/jenkins-plugin-manager-$PLUGIN_MANAGER_VERSION.jar && \
    rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime

FROM base

RUN echo -e "jenkins:x:1000:" >> /etc/group && \
    echo -e "jenkins:x:1000:1000:jenkins:/var/jenkins_home:/bin/sh" >> /etc/passwd && \  
    echo -e "jenkins:*:19295:0:99999:7:::" >> /etc/shadow && \
    microdnf -y update && microdnf -y install --setopt=install_weak_deps=0 java-11-openjdk unzip findutils \
    && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime
    
COPY --from=builder /usr/sbin/packer /usr/sbin/packer
COPY --from=builder /usr/share/jenkins/jenkins.war /usr/share/jenkins/jenkins.war
COPY --from=builder /opt/jenkins-plugin-manager.jar /opt/jenkins-plugin-manager.jar

COPY src/jenkins-plugin-cli /bin/jenkins-plugin-cli 
COPY src/jenkins-support /usr/local/bin/jenkins-support
COPY src/jenkins.sh /usr/local/bin/jenkins.sh
RUN mkdir -p /usr/share/jenkins/ref /usr/share/jenkins/ref/plugins /var/jenkins_home && \
    chown -R jenkins:jenkins /usr/share/jenkins /var/jenkins_home /usr/local/bin/jenkins.sh && \
    chmod 500 /usr/local/bin/jenkins.sh && chmod +x /usr/local/bin/jenkins-support

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
