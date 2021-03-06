FROM maven:3.5-jdk-8-alpine
VOLUME /usr/src/app
VOLUME /root/.m2/repository
# START - Setup Sonar Scanner
ENV SONAR_VERSION 3.0.3.778
ENV SONAR_FOLDER sonar-scanner-cli-${SONAR_VERSION}
ENV SONAR_EXE /sonar-scanner-${SONAR_VERSION}/bin/sonar-scanner
RUN curl --insecure -L --output sonar.zip https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_VERSION}.zip
RUN unzip sonar.zip
RUN rm sonar.zip
RUN chmod +x ${SONAR_EXE}
# END - Setup Sonar Scanner

RUN apk update
RUN apk add perl-xml-twig git openssh-client
RUN rm -rf /var/cache/apk/*

#http://dev.im-bot.com/docker-select-caching/
ARG CACHEBUST=1

# Make ssh dir
RUN mkdir -p /root/.ssh/
# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

WORKDIR /usr/src/app
ENTRYPOINT chmod +x ${ENTRYPOINT_SCRIPT} && ${ENTRYPOINT_SCRIPT}