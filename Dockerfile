FROM python:3.10
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN mkdir /app
WORKDIR /app
RUN pip install -U poetry

ADD . /app
RUN poetry install --only main

ENV PYTHONPATH .
