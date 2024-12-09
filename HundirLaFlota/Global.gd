extends Node

# Variables globales
var barcos_jugador = []  # Tablero de 10x10 (100 casillas)

func _ready():
	# Inicializar el tablero de barcos del jugador
	barcos_jugador.resize(100)
	for i in range(barcos_jugador.size()):
		barcos_jugador[i] = ""  # Todas las casillas vacías inicialmente

func reset_game():
	# Reinicia las variables globales para un nuevo juego
	for i in range(barcos_jugador.size()):
		barcos_jugador[i] = ""
