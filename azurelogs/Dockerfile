FROM azuresdk/azure-cli-python

WORKDIR /src

COPY metrics /src/

ADD start.sh /src

ENTRYPOINT [ "./start.sh" ]