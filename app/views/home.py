#!/bin/python3

import streamlit as st

st.title("Bienvenido a AquaLife")
st.markdown("""
Panel de control de **AquaSolutions** para el análisis de la comunidad,
la gestión de conversaciones, la documentación de especies y la auditoría de precios.
Usa el menú lateral para acceder a cada módulo.
""")

st.divider()
col1, col2 = st.columns(2)

with col1:
	st.subheader('Analitica')
	st.write('Consultas 3.a - 3.i')
	st.page_link('views/query_selector.py', label='Selector de Consultas')

