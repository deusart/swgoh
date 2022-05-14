import config
import pyodbc

 
def select(query):    
    connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+config.SERVER+';DATABASE='+config.DATABASE+';UID='+config.SQLUSERNAME+';PWD='+ config.SQLPASSWORD)
    cursor = connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    connection.close()
    return data

def execute(query):    
    connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+config.SERVER+';DATABASE='+config.DATABASE+';UID='+config.SQLUSERNAME+';PWD='+ config.SQLPASSWORD)
    cursor = connection.cursor()
    cursor.execute(query)
    connection.commit()
    connection.close()