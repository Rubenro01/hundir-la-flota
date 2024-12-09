extends Control

# Referencias a los nodos
@onready var colocacion_panel = $ColocacionPanel  # Panel de instrucciones
@onready var audio_player = AudioStreamPlayer.new()  # Nodo para reproducir sonidos

# Variables para almacenar los barcos y sus emojis
var barco_seleccionado = null  # El barco actualmente seleccionado
var barcos_disponibles = {
	"Portaaviones": {"tamaño": 5, "colocado": false, "emoji": "🚢"},
	"Acorazado": {"tamaño": 4, "colocado": false, "emoji": "🛥️"},
	"Crucero": {"tamaño": 3, "colocado": false, "emoji": "⛴️"},
	"Destructor1": {"tamaño": 2, "colocado": false, "emoji": "🚤"},
	"Destructor2": {"tamaño": 2, "colocado": false, "emoji": "🚤"},
	"Submarino1": {"tamaño": 1, "colocado": false, "emoji": "🛶"},
	"Submarino2": {"tamaño": 1, "colocado": false, "emoji": "🛶"}
}

# Controlar las casillas seleccionadas
var casilla_inicial = null
var casilla_final = null

# Arreglo para las casillas del tablero
var casillas = []

func _ready():
	# Añadir AudioStreamPlayer al nodo
	add_child(audio_player)

	# Conectar cada barco a una función de selección
	$VBoxContainer/Portaaviones.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Portaaviones"))
	$VBoxContainer/Acorazado.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Acorazado"))
	$VBoxContainer/Crucero.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Crucero"))
	$VBoxContainer/Destructor1.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Destructor1"))
	$VBoxContainer/Destructor2.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Destructor2"))
	$VBoxContainer/Submarino1.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Submarino1"))
	$VBoxContainer/Submarino2.pressed.connect(Callable(self, "_on_barco_seleccionado").bind("Submarino2"))

	# Configurar las casillas del tablero
	for button in $GridContainer.get_children():
		button.pressed.connect(Callable(self, "_on_casilla_seleccionada").bind(button))
		casillas.append(button)

	# Conectar los botones "Limpiar", "Continuar", "Aleatorio" e "Información"
	$LimpiarButton.pressed.connect(Callable(self, "_on_LimpiarButton_pressed"))
	$ContinuarButton.pressed.connect(Callable(self, "_on_ContinuarButton_pressed"))
	$AleatorioButton.pressed.connect(Callable(self, "_on_AleatorioButton_pressed"))
	$InfoButton.pressed.connect(_on_info_button_pressed)
	$ColocacionPanel/CerrarButton.pressed.connect(_on_cerrar_button_pressed)
	
	# Deshabilitar el botón "Continuar" al comienzo
	$ContinuarButton.disabled = true

# Función para reproducir sonido
func reproducir_sonido(ruta_sonido):
	var sonido = ResourceLoader.load(ruta_sonido)  # Usar ResourceLoader.load para rutas dinámicas
	if sonido and sonido is AudioStream:  # Verificar que el recurso es válido y es un AudioStream
		audio_player.stream = sonido
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", ruta_sonido)

# Función para limpiar el tablero
func _on_LimpiarButton_pressed():
	reproducir_sonido("res://Sonidos/Limpiar.wav")  # Ruta del sonido para limpiar
	for button in casillas:
		button.text = ""
	for barco in barcos_disponibles.keys():
		barcos_disponibles[barco]["colocado"] = false
	barco_seleccionado = null
	Global.barcos_jugador.fill("")
	$ContinuarButton.disabled = true

# Función para continuar
func _on_ContinuarButton_pressed():
	if todos_barcos_colocados():
		reproducir_sonido("res://Sonidos/Limpiar.wav")  # Ruta del sonido para comenzar
		print("Todos los barcos colocados. Continuar al siguiente paso.")
		get_tree().change_scene_to_file("res://GameScreen.tscn")
	else:
		print("Aún no todos los barcos están colocados")

# Función para seleccionar un barco
func _on_barco_seleccionado(barco):
	if barcos_disponibles[barco]["colocado"]:
		print("Este barco ya ha sido colocado.")
		return
	barco_seleccionado = barco
	print("Barco seleccionado:", barco)

# Función que se ejecuta cuando se selecciona una casilla
func _on_casilla_seleccionada(casilla):
	if barco_seleccionado == null:
		print("Por favor, selecciona un barco primero.")
		return

	var index = casillas.find(casilla)
	if casilla_inicial == null:
		# Primera casilla seleccionada
		casilla_inicial = index
		print("Casilla inicial seleccionada:", index)
	else:
		# Segunda casilla seleccionada
		casilla_final = index
		print("Casilla final seleccionada:", index)

		# Verificar si el barco se puede colocar
		var tamaño = barcos_disponibles[barco_seleccionado]["tamaño"]
		if puede_colocar_barco(casilla_inicial, casilla_final, tamaño):
			colocar_barco(casilla_inicial, casilla_final, tamaño)
			barcos_disponibles[barco_seleccionado]["colocado"] = true
			barco_seleccionado = null  # Reiniciar selección de barco

			# Verificar si todos los barcos han sido colocados
			if todos_barcos_colocados():
				$ContinuarButton.disabled = false
		else:
			print("No se puede colocar el barco en las casillas seleccionadas.")

		# Reiniciar las casillas seleccionadas
		casilla_inicial = null
		casilla_final = null

# Función para colocar el barco entre la casilla inicial y la final
func colocar_barco(index_inicial, index_final, tamaño):
	var emoji = barcos_disponibles[barco_seleccionado]["emoji"]
	var fila_inicial = index_inicial / 10
	var columna_inicial = index_inicial % 10

	if fila_inicial == index_final / 10:  # Colocación horizontal
		for i in range(tamaño):
			casillas[index_inicial + i].text = emoji
			Global.barcos_jugador[index_inicial + i] = emoji  # Almacenar en el tablero global
	elif columna_inicial == index_final % 10:  # Colocación vertical
		for i in range(tamaño):
			casillas[index_inicial + i * 10].text = emoji
			Global.barcos_jugador[index_inicial + i * 10] = emoji  # Almacenar en el tablero global

# Función para verificar si se puede colocar el barco entre las casillas inicial y final
func puede_colocar_barco(index_inicial, index_final, tamaño):
	var fila_inicial = index_inicial / 10
	var columna_inicial = index_inicial % 10
	var fila_final = index_final / 10
	var columna_final = index_final % 10

	# Verificar colocación horizontal (misma fila)
	if fila_inicial == fila_final:
		if abs(columna_final - columna_inicial) + 1 == tamaño:
			for i in range(tamaño):
				if casillas[index_inicial + i].text != "":
					return false  # No puede superponerse
			return true
	elif columna_inicial == columna_final:  # Verificar colocación vertical (misma columna)
		if abs(fila_final - fila_inicial) + 1 == tamaño:
			for i in range(tamaño):
				if casillas[index_inicial + i * 10].text != "":
					return false  # No puede superponerse
			return true
	return false

# Función que se ejecuta al pulsar el botón Aleatorio
func _on_AleatorioButton_pressed():
	_on_LimpiarButton_pressed()  # Limpiar el tablero antes de colocar barcos aleatorios
	
	for barco in barcos_disponibles.keys():
		var tamaño = barcos_disponibles[barco]["tamaño"]
		var emoji = barcos_disponibles[barco]["emoji"]
		var colocado = false
		
		while not colocado:
			var orientacion = randi() % 2  # 0 para horizontal, 1 para vertical
			var index_inicial = randi() % 100  # Generar posición inicial aleatoria
			
			if orientacion == 0:  # Colocación horizontal
				if (index_inicial % 10) + tamaño <= 10:
					var espacio_libre = true
					for i in range(tamaño):
						if casillas[index_inicial + i].text != "":
							espacio_libre = false
							break
					if espacio_libre:
						for i in range(tamaño):
							casillas[index_inicial + i].text = emoji
							Global.barcos_jugador[index_inicial + i] = emoji
						colocado = true
			else:  # Colocación vertical
				if (index_inicial / 10) + tamaño <= 10:
					var espacio_libre = true
					for i in range(tamaño):
						if casillas[index_inicial + (i * 10)].text != "":
							espacio_libre = false
							break
					if espacio_libre:
						for i in range(tamaño):
							casillas[index_inicial + (i * 10)].text = emoji
							Global.barcos_jugador[index_inicial + (i * 10)] = emoji
						colocado = true
	
		barcos_disponibles[barco]["colocado"] = true
	
	if todos_barcos_colocados():
		$ContinuarButton.disabled = false


# Función para verificar si todos los barcos han sido colocados
func todos_barcos_colocados():
	for barco in barcos_disponibles.keys():
		if not barcos_disponibles[barco]["colocado"]:
			return false
	return true

# Función para mostrar el panel de instrucciones
func _on_info_button_pressed() -> void:
	colocacion_panel.visible = true

# Función para cerrar el panel de instrucciones
func _on_cerrar_button_pressed() -> void:
	colocacion_panel.visible = false
