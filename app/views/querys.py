#!/bin/python3

from collections import defaultdict
import streamlit as st

from app.db import get_query

CATALOG_NAMES = [
	'Termometro de la comunidad',
	'Publicaciones mejor recibidas por la comunidad',
	'Perfil demogr´afico de la comunidad',
	'Tendencias de contribucion segun el tipo de agua',
	'Vendedores mejor calificados',
	'Trigger de auditorıa de precios',
	'Procedimiento almacenado para analisis de actividad de usuario',
	'Analisis de influencers y su impacto en ventas',
	'Deteccion de patrones de comportamiento anomalo en vendedores'
]
CATALOG_QUERYS = ['3_'+x+'.sql' for x in 'abcdefghi']

CATALOG = defaultdict(str)

for i,j in zip(CATALOG_NAMES, CATALOG_QUERYS):
	CATALOG[i] = j

name = st.selectbox('Consulta', CATALOG_NAMES)

with st.spinner('Ejecutando..'):
	df = get_query(CATALOG[name])
	st.dataframe(df, use_container_width=True)

