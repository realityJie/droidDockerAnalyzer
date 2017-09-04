FROM gsgtzq/droid-docker-analyzer
RUN pip install redis \
requests \
flask \
flask-sqlalchemy \
sqlalchemy \
gunicorn \
celery \
PyMySQL

