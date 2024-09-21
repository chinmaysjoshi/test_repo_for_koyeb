FROM python:3.8

COPY . /app
WORKDIR /app

RUN mkdir __logger

# Add rclone's official GPG key
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    rm rclone-current-linux-amd64.deb

# Verify rclone installation (optional)
RUN rclone version

# set display port to avoid crash
ENV DISPLAY=:99

RUN pip install --upgrade pip

RUN pip install -r requirements.txt

CMD ["python", "./app.py"]
