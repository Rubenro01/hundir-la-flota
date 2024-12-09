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

# Labels de los barcos de la IA
var labels_barcos = {}

# Variables para controlar el temporizador de la IA
var ia_timer = null

func _ready():
	# Cargar el mensaje de turno
	mensaje_turno = $Label
	
	# Inicializar los tableros
	tablero_jugador = inicializar_tablero($GridContainer)
	tablero_ia = inicializar_tablero($GridContainerIA)

	# Inicializar los LABEL de los barcos
	labels_barcos = {
		"Portaaviones": $Portaaviones,
		"Acorazado": $Acorazado,
		"Crucero": $Crucero,
		"Destructor1": $Destructor1,
		"Destructor2": $Destructor2,
		"Submarino1": $Submarino1,
		"Submarino2": $Submarino2,
		"PortaavionesIA": $PortaavionesIA,
		"AcorazadoIA": $AcorazadoIA,
		"CruceroIA": $CruceroIA,
		"DestructorIA1": $DestructorIA1,
		"DestructorIA2": $DestructorIA2,
		"SubmarinoIA1": $SubmarinoIA1,
		"SubmarinoIA2": $SubmarinoIA2,
	}

	# Ocultar todos los LABEL inicialmente
	for label in labels_barcos.values():
		if label != null:
			label.visible = false

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
		if barcos_jugador[i] != "":  # Si hay un barco en la posición
			tablero_jugador[i].text = barcos_jugador[i]

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
							tablero_ia[index_inicial + i].set_meta("barco", barco["nombre"])  # Asignar el nombre del barco
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
							tablero_ia[index_inicial + (i * 10)].set_meta("barco", barco["nombre"])  # Asignar el nombre del barco
							tablero_ia[index_inicial + (i * 10)].text = " "  # Solo se revela cuando el jugador acierta
						colocado = true

# Función que se ejecuta cuando se selecciona una casilla del tablero de la IA
func _on_casilla_seleccionada(button):
	if turno_jugador:
		atacar_casilla(tablero_ia, button)

# Función para manejar el ataque del jugador
func atacar_casilla(tablero, button):
	if button.text == "":
		button.text = "💧"
		mensaje_turno.text = "Turno de la IA"
		turno_jugador = false
		ia_timer.start(1)  # Esperar 1 segundo antes de que la IA ataque
	elif button.text == " ":
		button.text = "❌"
		reproducir_sonido("res://Sonidos/Barco.wav")  # Reproduce el sonido cuando se marca un `❌`
		mensaje_turno.text = "¡Golpe! Sigue atacando."
		verificar_hundimiento(button.get_meta("barco"))  # Verificar si el barco fue hundido
		verificar_victoria("jugador")  # Verificar si el jugador ha ganado
	else:
		print("Casilla ya atacada")

# Nueva función para verificar si un barco ha sido hundido
func verificar_hundimiento(barco_nombre):
	if barco_nombre:
		var hundido = true
		for button in tablero_ia:
			if button.get_meta("barco") == barco_nombre and button.text == " ":
				hundido = false
				break
		if hundido and labels_barcos.has(barco_nombre):
			labels_barcos[barco_nombre].visible = true  # Mostrar el LABEL del barco hundido

# Función para manejar el ataque de la IA
func atacar_ia():
	var casilla_ia = elegir_casilla_aleatoria(tablero_jugador)
	
	if casilla_ia.text == "":
		casilla_ia.text = "💧"
		mensaje_turno.text = "Turno del Jugador"
		turno_jugador = true
	elif casilla_ia.text in ["🚢", "🛥️", "⛴️", "🚤", "🛶"]:
		casilla_ia.text = "❌"
		reproducir_sonido("res://Sonidos/Barco.wav")  # Reproduce el sonido cuando se marca un `❌`
		mensaje_turno.text = "¡Golpe de la IA! Sigue atacando."
		verificar_barcos_derribados()  # Verificar si algún barco fue hundido
		verificar_victoria("ia")
		ia_timer.start(1)

# Función para reproducir sonido
func reproducir_sonido(ruta_sonido):
	var sonido = ResourceLoader.load(ruta_sonido)  # Cargar el sonido dinámicamente
	if sonido and sonido is AudioStream:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = sonido
		audio_player.play()
		
	else:
		print("Error al cargar el sonido:", ruta_sonido)

func contar_barcos_en_tablero(simbolo):
	var contador = 0
	for button in tablero_jugador:
		if button.text == simbolo:
			contador += 1
	return contador

# Función para elegir una casilla aleatoria no atacada
func elegir_casilla_aleatoria(tablero):
	var posibles = []
	for button in tablero:
		if button.text == "" or button.text in ["🚢", "🛥️", "⛴️", "🚤", "🛶"]:
			posibles.append(button)
	return posibles[randi() % posibles.size()]

# Función para verificar si los barcos del jugador han sido derribados
func verificar_barcos_derribados():
	# Verificar cada barco individualmente
	# Portaaviones
	if !existen_barcos_en_tablero("🚢") and labels_barcos["PortaavionesIA"].visible == false:
		print("PortaavionesIA hundido")
		labels_barcos["PortaavionesIA"].visible = true

	# Acorazado
	if !existen_barcos_en_tablero("🛥️") and labels_barcos["AcorazadoIA"].visible == false:
		print("AcorazadoIA hundido")
		labels_barcos["AcorazadoIA"].visible = true

	# Crucero
	if !existen_barcos_en_tablero("⛴️") and labels_barcos["CruceroIA"].visible == false:
		print("CruceroIA hundido")
		labels_barcos["CruceroIA"].visible = true

	# Lógica para los destructores (🚤)
	var cantidad_destructores = contar_barcos_en_tablero("🚤")
	if cantidad_destructores <= 2 and labels_barcos["DestructorIA1"].visible == false:
		print("DestructorIA1 hundido")
		labels_barcos["DestructorIA1"].visible = true
	if cantidad_destructores == 0 and labels_barcos["DestructorIA2"].visible == false:
		print("DestructorIA2 hundido")
		labels_barcos["DestructorIA2"].visible = true

	# Lógica para los submarinos (🛶)
	var cantidad_submarinos = contar_barcos_en_tablero("🛶")
	if cantidad_submarinos <= 1 and labels_barcos["SubmarinoIA1"].visible == false:
		print("SubmarinoIA1 hundido")
		labels_barcos["SubmarinoIA1"].visible = true
	if cantidad_submarinos == 0 and labels_barcos["SubmarinoIA2"].visible == false:
		print("SubmarinoIA2 hundido")
		labels_barcos["SubmarinoIA2"].visible = true

# Función para verificar si hay barcos específicos en el tablero del jugador
func existen_barcos_en_tablero(simbolo, meta = null):
	for button in tablero_jugador:
		if button.text == simbolo and (meta == null or button.get_meta("barco") == meta):
			return true
	return false

# Función para verificar si alguien ha ganado
func verificar_victoria(jugador):
	if jugador == "jugador":
		var todos_hundidos = true
		for button in tablero_ia:
			if button.text == " ":
				todos_hundidos = false
				break
		if todos_hundidos:
			mensaje_turno.text = "¡Has ganado!"
			turno_jugador = false
			mostrar_fin_panel(true)  # Llama al panel de victoria
	elif jugador == "ia":
		var todos_hundidos = true
		for button in tablero_jugador:
			if button.text in ["🚢", "🛥️", "⛴️", "🚤", "🛶"]:
				todos_hundidos = false
				break
		if todos_hundidos:
			mensaje_turno.text = "La IA ha ganado."
			turno_jugador = false
			mostrar_fin_panel(false)  # Llama al panel de derrota

# Función para mostrar el panel final
func mostrar_fin_panel(jugador_gana):
	$FinPanel.visible = false  # Asegúrate de que el panel esté oculto inicialmente
	await get_tree().create_timer(1.0).timeout  # Esperar 1 segundo

	$FinPanel.visible = true  # Mostrar el panel
	if jugador_gana:
		$FinPanel/LabelVictoria.visible = true
		$FinPanel/LabelDerrota.visible = false
	else:
		$FinPanel/LabelVictoria.visible = false
		$FinPanel/LabelDerrota.visible = true

# Función para cerrar el juego desde el botón
func _on_CerrarButton_pressed():
	get_tree().quit()  # Cierra la aplicación
