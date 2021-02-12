FROM google/cloud-sdk:slim

ARG TARGETARCH
ARG TARGETOS


# unzip
RUN apt-get install -y unzip bash jq && \
    rm -rf /var/lib/apt/lists/*

# terraform
ENV TERRAFORM 0.14.6
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM}_linux_amd64.zip && \
  chmod +x terraform && mv terraform /usr/bin && rm terraform_${TERRAFORM}_linux_amd64.zip

# jx
ENV VERSION 3.1.246

RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -L https://github.com/jenkins-x/jx-cli/releases/download/v${VERSION}/jx-cli-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

# lets install the boot plugins
RUN jx upgrade plugins --boot --path /usr/bin

# lets install the admin plugin
RUN jx admin help

COPY run.sh /run.sh
ENTRYPOINT ["/bin/bash"]
CMD ["run.sh"]


LABEL org.opencontainers.image.source https://github.com/jenkins-x-images/terraform-operator-gcp
