import os
import pyodbc

from dotenv import load_dotenv
load_dotenv()

def get_db_connection():
    server = os.getenv('AZURE_DB_SERVER')
    database = os.getenv('AZURE_DB_NAME')
    username = os.getenv('AZURE_DB_USER')
    password = os.getenv('AZURE_DB_PASSWORD')
    driver = '{ODBC Driver 17 for SQL Server}'
    connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}'
    conn = pyodbc.connect(connection_string)
    return conn

def rows_to_list(cursor):
    columns = [column[0] for column in cursor.description]  # Get column names
    rows = cursor.fetchall()
    results = []
    for row in rows:
        results.append(dict(zip(columns, row)))
    return results

