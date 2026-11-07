#!/bin/python3

from collections import defaultdict
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent
SQL_DIR = ROOT_DIR/'sql'


CATALOG_NAMES = [
	'Termometro de la comunidad',
	'Publicaciones mejor recibidas por la comunidad',
	'Perfil demografico de la comunidad',
	'Tendencias de contribucion segun el tipo de agua',
	'Vendedores mejor calificados',
	'Procedimiento almacenado para analisis de actividad de usuario',
	'Analisis de influencers y su impacto en ventas',
	'Deteccion de patrones de comportamiento anomalo en vendedores'
]
CATALOG_QUERY = ['3_'+x+'.sql' for x in 'abcdeghi']

CATALOG = defaultdict(str)

for i,j in zip(CATALOG_NAMES, CATALOG_QUERY):
	CATALOG[i] = j