FROM python:3.8.5

RUN mkdir /code
WORKDIR /code
COPY requirements.txt .
RUN pip3 install -r requirements.txt && \
    pip3 install gunicorn
COPY . .
CMD gunicorn api_yamdb.wsgi:application --bind 0.0.0.0:8000
