#!/bin/python3

import streamlit as st

st.set_page_config(
    page_title="AquaLife · Panel de control",
    page_icon="🐠",
    layout="wide",
    initial_sidebar_state="expanded",
)

pages = {
	'General': [
		st.Page('views/home.py', title='Bienvenida', default=True)
	],
	'Analisis y Seleccion': [
		st.Page('views/query_selector.py', title = 'Consultas'),
		st.Page('views/user_analysis.py', title = 'Analisis de Usuarios')
	],
	'Gestion y Exploracion':[
		st.Page('views/doc_explorer.py', title = 'Explorador de Documentos'),
		st.Page('views/product_price_manager.py', title = 'Gestor de Precios de Productos'),
		st.Page('views/chat_manager.py', title = 'Gestor de chats')
	]
}


with st.sidebar:
	st.caption('AquaLife Solutions')
	st.session_state.nombre_usuario = st.text_input(
		label="Tu nombre",
		value=st.session_state.get("nombre_usuario", ""),
		key="idu_input"
	)
	if st.session_state.nombre_usuario:
		st.caption(f"Sessión {st.session_state.nombre_usuario}")
	else:
		st.caption('Introdcue tu nombre para auditar cambios')

st.navigation(pages, position='sidebar', expanded=True).run()
