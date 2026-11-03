#!/bin/python3

import pandas as pd
import pymysql
import streamlit as st
from config import SQL_DIR


def connection():
	return pymysql.connect(
		host = 'localhost',
		port = 3306,
		user = 'aqualife_user',
		password = 'aqualife_pass',
		database = 'AquaLife'
	)

@st.cache_data()
def execute_dql(name: str):
	connect = connection()

	sql = (SQL_DIR/name).read_text()
	try:
		result = pd.read_sql(sql,connect)
		return result
	finally :
		connect.close()


def execute_dml(sql: str, params: tuple = (), session_vars: dict | None = None):

	connect = connection()
	try:
		with connect.cursor() as cur:
			if session_vars:
				for k, v in session_vars.items():
					cur.execute(f"SET @{k} = %s", (v,))
			cur.execute(sql, params)
		connect.commit()
	finally:
		connect.close()
