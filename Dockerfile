FROM centos:latest

## Update our container and install a few packages
RUN yum upgrade -y \
    && yum install -y \
       curl \
       gcc \
    && yum clean all \

    ## Create base folder and download our files
    && mkdir -p /source \
    && curl -s http://www.bratch.co.uk/udprelay/files/udprelay-1.2.tar.gz | tar -xzC /source \

    ## Compile out code
    && cc -O /source/udprelay-1.2/udprelay.c -o /udprelay

## Start here
ENTRYPOINT ["/udprelay"]
CMD ["--help"]