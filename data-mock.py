#!/usr/bin/python3

from datetime import datetime
from faker import Faker
import psycopg2
import time
import os


BATCH_SIZE = 20
UPDATE_FREQUENCY = 10
ITERATION = 100
HOSTNAME = 'localhost'

fake = Faker()
Faker.seed(datetime.now())


def insert_user_record(connection, cursor):
    print("inserting records to user table...")
    pg_insert = """
        INSERT INTO users
            (first_name, last_name, email)
        VALUES
            (%s, %s, %s)
    """
    for _ in range(BATCH_SIZE):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = fake.email()

        cursor.execute(pg_insert, (first_name, last_name, email))

    connection.commit()

    print(f"{BATCH_SIZE} records has been successfully added")


if __name__ == "__main__":
    try:
        connection = psycopg2.connect(
            user = "postgres",
            password = "postgres",
            host = HOSTNAME,
            port = "5432",
            database = "postgres"
        )
        cursor = connection.cursor()

        for i in range(ITERATION):
            insert_user_record(connection, cursor)
            time.sleep(UPDATE_FREQUENCY)

    except (Exception, psycopg2.Error) as error:
        print("Error connecting to PostgreSQL database", error)
        connection = None

    finally:
        if connection != None:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is now closed")
