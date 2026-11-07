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

@st.cache_data()
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

@st.cache_data()
def execute_sp_user_analisys(params: tuple = ()):
	connect = connection()
	try:
		with connect.cursor(pymysql.cursors.DictCursor) as cur:
			cur.execute(
				'CALL sp_analisis_usuario(%s, %s, %s)',
				params
			)
			result = {}
			while 1:
				res = cur.fetchone()
				if res:
					result.update(res)
				if not cur.nextset():
					break
			return result
	finally:
		connect.close()

