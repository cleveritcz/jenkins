# Jenkins

## Information
- It is running based on Rocky Linux 9 minimal docker image with zero vulnerabilities and with Git and the latest Ansible
- Slim versions are without Ansible and plugins (just Jenkins and Git)
- You can use also Jenkins-agent from my build based on Rocky Linux 9 minimal => [Jenkins-agent](https://hub.docker.com/repository/docker/cleveritcz/jenkins-agent)

## Plugins
- kubernetes, git, blueocean, docker-workflow, workflow-aggregator, configuration-as-code, ansible, locale

## Recommended 
- Use with this helm chart [jenkinsci](https://github.com/jenkinsci/helm-charts)
