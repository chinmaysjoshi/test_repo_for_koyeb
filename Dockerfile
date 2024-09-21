FROM python:3.8

COPY . /app
WORKDIR /app

RUN mkdir __logger

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

RUN CHROME_VERSION=$(google-chrome --version | sed 's/Google Chrome //g' | sed 's/ .*//g') && \
    wget https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip -d /usr/local/bin/ && \
    rm chromedriver-linux64.zip

# Add rclone's official GPG key
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    rm rclone-current-linux-amd64.deb

# Install mega cmd
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb && \
    apt-get install -yf ./megacmd-xUbuntu_24.04_amd64.deb && \
    rm -f megacmd-xUbuntu_24.04_amd64.deb
    
# Verify rclone installation (optional)
RUN rclone version

# set display port to avoid crash
ENV DISPLAY=:99

RUN pip install --upgrade pip

RUN pip install -r requirements.txt

CMD ["python", "./app.py"]
