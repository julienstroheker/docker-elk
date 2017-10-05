FROM azuresdk/azure-cli-python

RUN apk update && apk add curl

WORKDIR /src

COPY . /src/

ENTRYPOINT [ "./start.sh" ]