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
	'Analitica': [
		st.Page('views/querys.py', title='Consultas')
	]
}


with st.sidebar :
	st.divider()
	st.caption('AquaLife Solutions')

st.navigation(pages, position='sidebar', expanded=True).run()
