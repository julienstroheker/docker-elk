FROM azuresdk/azure-cli-python

RUN apk update && apk add curl

WORKDIR /src

COPY metrics /src/metrics/

ADD start.sh /src

ENTRYPOINT [ "./start.sh" ]