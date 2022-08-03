FROM rust:1-slim-bullseye AS builder

ARG MDBOOK_VER=0.4.21
ARG MDBOOK_PUML_VER=0.8.0

ARG PUML_VER=1.2022.6
ARG PUML_CHKSUM="204def7102790f55d4adad7756b9c1c19cefcb16e7f7fbc056abb40f8cbe4eae"
ARG PUML_URL=https://github.com/plantuml/plantuml/releases/download/v${PUML_VER}/plantuml-${PUML_VER}.jar

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    openssl


RUN cargo install --version "${MDBOOK_VER}" mdbook
RUN cargo install --version "${MDBOOK_PUML_VER}" mdbook-plantuml --no-default-features

RUN curl --location --output /opt/plantuml.jar "${PUML_URL}" \
    && echo "${PUML_CHKSUM} /opt/plantuml.jar" | sha256sum -c -


FROM debian:bullseye-slim

COPY --from=builder /usr/local/cargo/bin/mdbook /usr/local/bin/mdbook
COPY --from=builder /usr/local/cargo/bin/mdbook-plantuml /usr/local/bin/mdbook-plantuml
COPY --from=builder /opt/plantuml.jar /opt/plantuml.jar
COPY ./plantuml.sh /usr/bin/plantuml

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
    fontconfig \
    graphviz \
    openjdk-17-jre \
    openssl

WORKDIR /book
ENTRYPOINT [ "mdbook" ]
CMD [ "--help" ]
