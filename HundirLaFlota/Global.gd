extends Node

# Variable para almacenar la disposición de los barcos del jugador
var barcos_jugador = []

func _ready():
	# Inicializa el arreglo para un tablero de 10x10 (100 casillas)
	barcos_jugador.resize(100)
	for i in range(barcos_jugador.size()):
		barcos_jugador[i] = ""  # Inicialmente, todas las casillas están vacías
