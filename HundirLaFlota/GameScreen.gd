extends Control

# Tableros
var tablero_jugador = []  # Tablero del jugador (GridContainer)
var tablero_ia = []  # Tablero de la IA (GridContainerIA)

# Variables para controlar los turnos
var turno_jugador = true  # El jugador comienza
var mensaje_turno = null  # Etiqueta para mostrar el turno actual

# Lista de barcos de la IA
var barcos_ia = [
	{"nombre": "Portaaviones", "tamaño": 5},
	{"nombre": "Acorazado", "tamaño": 4},
	{"nombre": "Crucero", "tamaño": 3},
	{"nombre": "Destructor1", "tamaño": 2},
	{"nombre": "Destructor2", "tamaño": 2},
	{"nombre": "Submarino1", "tamaño": 1},
	{"nombre": "Submarino2", "tamaño": 1}
]

# Variables para controlar el temporizador de la IA
var ia_timer = null

# Función que se ejecuta cuando la escena está lista
func _ready():
	# Cargar el mensaje de turno
	mensaje_turno = $Label
	
	# Inicializar los tableros
	tablero_jugador = inicializar_tablero($GridContainer)
	tablero_ia = inicializar_tablero($GridContainerIA)

	# Transferir la disposición de los barcos del jugador desde la pantalla anterior
	transferir_barcos_jugador()

	# Colocar los barcos de la IA aleatoriamente
	colocar_barcos_ia()

	# Mostrar que es el turno del jugador al inicio
	mensaje_turno.text = "Turno del Jugador"

	# Configurar el temporizador para la IA
	ia_timer = Timer.new()
	add_child(ia_timer)
	ia_timer.one_shot = true
	ia_timer.connect("timeout", Callable(self, "atacar_ia"))

# Función para inicializar el tablero
func inicializar_tablero(grid):
	var botones = []
	for button in grid.get_children():
		button.pressed.connect(Callable(self, "_on_casilla_seleccionada").bind(button))
		botones.append(button)
	return botones

# Función para transferir la disposición de los barcos del jugador
func transferir_barcos_jugador():
	var barcos_jugador = Global.barcos_jugador  # Asume que los datos se transfieren desde una variable global
	
	# Aplicar la disposición de los barcos al tablero del jugador
	for i in range(tablero_jugador.size()):
		if barcos_jugador[i] == "·":  # Si hay un barco en la posición
			tablero_jugador[i].text = "·"

# Función para colocar los barcos de la IA de manera aleatoria
func colocar_barcos_ia():
	for barco in barcos_ia:
		var colocado = false
		while not colocado:
			var orientacion = randi() % 2  # 0 para horizontal, 1 para vertical
			var index_inicial = randi() % 100  # Elegir una casilla aleatoria en un tablero de 10x10
			
			if orientacion == 0:  # Colocación horizontal
				var fila = index_inicial / 10
				if (index_inicial % 10) + barco["tamaño"] <= 10:
					var espacio_libre = true
					for i in range(barco["tamaño"]):
						if tablero_ia[index_inicial + i].text != "":
							espacio_libre = false
							break
					if espacio_libre:
						for i in range(barco["tamaño"]):
							tablero_ia[index_inicial + i].text = " "  # Solo se revela cuando el jugador acierta
						colocado = true
			else:  # Colocación vertical
				var columna = index_inicial % 10
				if (index_inicial / 10) + barco["tamaño"] <= 10:
					var espacio_libre = true
					for i in range(barco["tamaño"]):
						if tablero_ia[index_inicial + (i * 10)].text != "":
							espacio_libre = false
							break
					if espacio_libre:
						for i in range(barco["tamaño"]):
							tablero_ia[index_inicial + (i * 10)].text = " "  # Solo se revela cuando el jugador acierta
						colocado = true

# Función que se ejecuta cuando se selecciona una casilla del tablero de la IA
func _on_casilla_seleccionada(button):
	if turno_jugador:
		atacar_casilla(tablero_ia, button)

# Función para manejar el ataque del jugador
func atacar_casilla(tablero, button):
	if button.text == "":
		button.text = "A"
		mensaje_turno.text = "Turno de la IA"
		turno_jugador = false
		ia_timer.start(1)  # Esperar 1 segundo antes de que la IA ataque
	elif button.text == " ":
		button.text = "X"
		mensaje_turno.text = "¡Golpe! Sigue atacando."
		verificar_victoria("jugador")  # Verificar si el jugador ha ganado
	else:
		print("Casilla ya atacada")

# Función para manejar el ataque de la IA
func atacar_ia():
	var casilla_ia = elegir_casilla_aleatoria(tablero_jugador)
	
	if casilla_ia.text == "":
		casilla_ia.text = "A"
		mensaje_turno.text = "Turno del Jugador"
		turno_jugador = true
	elif casilla_ia.text == "·":
		casilla_ia.text = "X"
		mensaje_turno.text = "¡Golpe de la IA! Sigue atacando."
		verificar_victoria("ia")  # Verificar si la IA ha ganado
		ia_timer.start(1)  # Continuar atacando tras 1 segundo si golpea

# Función para elegir una casilla aleatoria no atacada
func elegir_casilla_aleatoria(tablero):
	var posibles = []
	for button in tablero:
		if button.text == "" or button.text == "·":  # Solo elegir casillas no atacadas
			posibles.append(button)
	return posibles[randi() % posibles.size()]

# Función para verificar si alguien ha ganado
func verificar_victoria(jugador):
	if jugador == "jugador":
		var todos_hundidos = true
		for button in tablero_ia:
			if button.text == " ":  # Si aún hay barcos, no ha ganado
				todos_hundidos = false
				break
		if todos_hundidos:
			mensaje_turno.text = "¡Has ganado!"
			turno_jugador = false  # Finalizar el juego
	elif jugador == "ia":
		var todos_hundidos = true
		for button in tablero_jugador:
			if button.text == "·":  # Si aún hay barcos, no ha ganado
				todos_hundidos = false
				break
		if todos_hundidos:
			mensaje_turno.text = "La IA ha ganado."
			turno_jugador = false  # Finalizar el juego
