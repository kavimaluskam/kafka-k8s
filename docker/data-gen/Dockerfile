FROM python:3.7-alpine

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

ADD data-mock.py app/main.py
RUN pip install psycopg2 && \
    pip install Faker

CMD python app/main.py