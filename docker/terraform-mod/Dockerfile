FROM hashicorp/terraform:1.9.7

LABEL org.opencontainers.image.source="https://github.com/mulecode/tool-set"
LABEL org.opencontainers.image.description="Terraform 1.9.7 Tool-set"

WORKDIR /opt/terraform
COPY Makefile ./Makefile
COPY *.tf ./
COPY modules ./modules

WORKDIR /opt/app

# Updates apk
RUN apk update &&  \
    apk upgrade && \
    apk add --no-cache make=4.4.1-r2 && \
    rm -rf /var/cache/apk/*

# Default entry point
ENTRYPOINT ["make", "-f", "/opt/terraform/Makefile"]
# Default command
CMD ["help"]
