FROM azuresdk/azure-cli-python

WORKDIR /src

COPY metrics /src/

ADD run.sh /src

ENTRYPOINT [ "./start.sh" ]