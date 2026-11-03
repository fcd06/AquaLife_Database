#!/bin/python3

import streamlit as st
from config import CATALOG
from db import execute_dql

name = st.selectbox('Consulta', CATALOG.keys())

with st.spinner('Ejecutando..'):
	df = execute_dql(CATALOG[name])
	st.dataframe(df, use_container_width=True)

