FROM python:3

RUN pip install redis

COPY . /app

WORKDIR /app 

RUN mkdir logs

CMD python3 pi_worker.py
