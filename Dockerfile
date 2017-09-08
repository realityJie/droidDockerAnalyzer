FROM gsgtzq/droid-docker-analyzer
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt  && apt-get update -y && apt-get install -y redis-server
