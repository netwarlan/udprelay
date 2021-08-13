FROM ubuntu:18.04

## Update our container and install a few packages
RUN apt-get update \
    && apt-get install -y \
        curl \
        gcc \
    && apt-get clean \
    && rm -rf /var/tmp/* /var/lib/apt/lists/* /tmp/* \
    
    ## Create base folder and download our files
    && mkdir -p /source \
    && curl -s http://www.bratch.co.uk/udprelay/files/udprelay-1.2.tar.gz | tar -xzC /source \

    ## Compile our code
    && cc -O /source/udprelay-1.2/udprelay.c -o /udprelay

## Start here
ENTRYPOINT ["/udprelay"]
CMD ["--help"]