FROM alpine
RUN apk --no-cache add \
    curl \
    jq \
    bash

COPY src/run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]