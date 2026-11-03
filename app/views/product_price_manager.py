#!/bin/python3
import streamlit as st
from db import execute_dml

st.title("Gestor de Precios de Productos")

if "nombre_usuario" not in st.session_state:
	st.warning("Introduce tu nombre de usuario en la barra lateral.")
	st.stop()

id_prod = st.number_input("ID Producto", min_value=1, step=1)
nuevo_precio = st.number_input("Nuevo precio", min_value=0.0, step=0.01, format="%.2f")

if st.button("Actualizar precio"):
	execute_dml(
		"UPDATE Producto SET Precio = %s WHERE IDProd = %s",
		(nuevo_precio, id_prod),
		session_vars={"nombre_usuario": st.session_state.nombre_usuario}
	)
	st.success(f"Precio actualizado. Trigger auditó con @nombre_usuario = {st.session_state.nombre_usuario}")