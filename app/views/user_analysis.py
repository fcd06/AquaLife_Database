#!/bin/python3

import pandas as pd
import streamlit as st
from db import execute_sp_user_analisys

st.title('Análisis de usuario')

with st.form("form_analisis_usuario"):
	col1, col2, col3 = st.columns(3)
	with col1:
		id_usuario = st.number_input("ID de usuario", min_value=1, step=1, value=1)
	with col2:
		fecha_inicio = st.date_input("Fecha inicio", value=pd.Timestamp("2025-01-01"))
	with col3:
		fecha_fin = st.date_input("Fecha fin", value=pd.Timestamp.today())

	enviar = st.form_submit_button("Analizar", use_container_width=True)

if enviar:
	if fecha_inicio > fecha_fin:
		st.error("La fecha de inicio no puede ser posterior a la fecha de fin.")
		st.stop()

	with st.spinner("Ejecutando procedimiento..."):
		resultado = execute_sp_user_analisys((id_usuario, fecha_inicio, fecha_fin))

	if not resultado:
		st.warning(f"No se encontraron datos para el usuario {id_usuario}.")
		st.stop()

	st.subheader("Resumen de actividad")

	col1, col2, col3, col4 = st.columns(4)
	col1.metric("Publicaciones", resultado.get("total_publicaciones", 0))
	col2.metric("Reacciones dadas", resultado.get("total_reacciones_dadas", 0))
	col3.metric("Reacciones recibidas", resultado.get("total_reacciones_recibidas", 0))
	col4.metric("Comentarios", resultado.get("total_comentarios", 0))

	col1, col2, col3 = st.columns(3)
	col1.metric("Compras", resultado.get("total_compras", 0))
	col2.metric("Monto gastado", f"${resultado.get('monto_gastado') or 0:,.2f}")
	col3.metric("Contribuciones", resultado.get("total_contribuciones", 0))

	st.divider()
	st.subheader("Especies destacadas")
	col1, col2 = st.columns(2)
	col1.metric(
		"Especie más contribuida",
		resultado.get("especie_mas_contribuida") or "Sin datos",
	)
	col2.metric(
		"Especie más comprada",
		resultado.get("especie_mas_vendida") or "Sin datos",
	)

	with st.expander("Ver resultado completo"):
		st.json(resultado)
