FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://mega.nz/linux/repo/xUbuntu_20.04/amd64/megacmd-xUbuntu_20.04_amd64.deb && \
    apt-get install -y ./megacmd-xUbuntu_20.04_amd64.deb && \
    rm -f megacmd-xUbuntu_20.04_amd64.deb

CMD ["mega-cmd"]

