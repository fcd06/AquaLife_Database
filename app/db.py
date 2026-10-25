#!/bin/python3
import pandas as pd
import pymysql

from config import SQL_DIR


def connection():
	return pymysql.connect(
		host = 'localhost',
		port = 3306,
		user = 'aqualife_user',
		password = 'aqualife_pass',
		database = 'AquaLife'
	)

def get_query(name: str):
	connect = connection()

	sql = (SQL_DIR/name).read_text()
	try:
		result = pd.read_sql(sql,connect)
		return result
	finally :
		connect.close()
