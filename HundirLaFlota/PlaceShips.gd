extends Control

# Variables para almacenar los barcos
var barco_seleccionado = null  # El barco actualmente seleccionado
var barcos_disponibles = {
	"Portaaviones": {"tamaño": 5, "colocado": false},
	"Acorazado": {"tamaño": 4, "colocado": false},
	"Crucero": {"tamaño": 3, "colocado": false},
	"Destructor1": {"tamaño": 2, "colocado": false},
	"Destructor2": {"tamaño": 2, "colocado": false},
	"Submarino1": {"tamaño": 1, "colocado": false},
	"Submarino2": {"tamaño": 1, "colocado": false}
}

# Controlar las casillas seleccionadas
var casilla_inicial = null
var casilla_final = null

# Arreglo para las casillas del tablero
var casillas = []

func _ready():
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

	# Conectar los botones "Limpiar" y "Continuar"
	$LimpiarButton.pressed.connect(Callable(self, "_on_LimpiarButton_pressed"))
	$ContinuarButton.pressed.connect(Callable(self, "_on_ContinuarButton_pressed"))
	
	# Deshabilitar el botón "Continuar" al comienzo
	$ContinuarButton.disabled = true

# Función que se ejecuta cuando se selecciona un barco
func _on_barco_seleccionado(barco_nombre):
	if barcos_disponibles[barco_nombre]["colocado"] == false:
		barco_seleccionado = barco_nombre
		casilla_inicial = null
		casilla_final = null
		print("Barco seleccionado: " + barco_nombre)

# Función que se ejecuta al hacer clic en una casilla del tablero
func _on_casilla_seleccionada(button):
	if barco_seleccionado != null:
		if casilla_inicial == null:
			casilla_inicial = button
			print("Casilla inicial seleccionada")
		elif casilla_final == null:
			casilla_final = button
			var index_inicial = casillas.find(casilla_inicial)
			var index_final = casillas.find(casilla_final)

			# Intentar colocar el barco
			if puede_colocar_barco(index_inicial, index_final, barcos_disponibles[barco_seleccionado]["tamaño"]):
				colocar_barco(index_inicial, index_final, barcos_disponibles[barco_seleccionado]["tamaño"])
				barcos_disponibles[barco_seleccionado]["colocado"] = true
				barco_seleccionado = null  # Deseleccionar el barco después de colocarlo
				casilla_inicial = null
				casilla_final = null

				# Verificar si ya se han colocado todos los barcos y habilitar el botón de "Continuar"
				if todos_barcos_colocados():
					$ContinuarButton.disabled = false
			else:
				print("Colocación inválida. Intenta de nuevo.")
				casilla_inicial = null
				casilla_final = null

# Función para verificar si se puede colocar el barco entre las casillas inicial y final
func puede_colocar_barco(index_inicial, index_final, tamaño):
	var fila_inicial = index_inicial / 10
	var columna_inicial = index_inicial % 10
	var fila_final = index_final / 10
	var columna_final = index_final % 10

	# Verificar colocación horizontal (misma fila)
	if fila_inicial == fila_final:
		if abs(columna_final - columna_inicial) + 1 == tamaño:
			if columna_inicial + tamaño > 10:
				print("El barco se sale del tablero horizontalmente.")
				return false
			for i in range(tamaño):
				if casillas[index_inicial + i].text != "":
					return false  # No puede superponerse
			return true
	elif columna_inicial == columna_final:
		if abs(fila_final - fila_inicial) + 1 == tamaño:
			if fila_inicial + tamaño > 10:
				print("El barco se sale del tablero verticalmente.")
				return false
			for i in range(tamaño):
				if casillas[index_inicial + i * 10].text != "":
					return false  # No puede superponerse
			return true
	return false

# Función para colocar el barco entre la casilla inicial y la final
func colocar_barco(index_inicial, index_final, tamaño):
	var fila_inicial = index_inicial / 10
	var columna_inicial = index_inicial % 10

	if fila_inicial == index_final / 10:  # Colocación horizontal
		for i in range(tamaño):
			casillas[index_inicial + i].text = "·"
			Global.barcos_jugador[index_inicial + i] = "·"  # Almacenar en el tablero global
	elif columna_inicial == index_final % 10:  # Colocación vertical
		for i in range(tamaño):
			casillas[index_inicial + i * 10].text = "·"
			Global.barcos_jugador[index_inicial + i * 10] = "·"  # Almacenar en el tablero global

	# Verificar si ya se han colocado todos los barcos
	if todos_barcos_colocados():
		$ContinuarButton.disabled = false

# Función para verificar si todos los barcos han sido colocados
func todos_barcos_colocados():
	for barco in barcos_disponibles.keys():
		if barcos_disponibles[barco]["colocado"] == false:
			return false
	return true

# Función para el botón de "Limpiar Tablero"
func _on_LimpiarButton_pressed():
	for button in casillas:
		button.text = ""
		button.disabled = false
	for barco in barcos_disponibles.keys():
		barcos_disponibles[barco]["colocado"] = false
	barco_seleccionado = null
	casilla_inicial = null
	casilla_final = null
	Global.barcos_jugador.fill("")  # Limpiar el tablero global
	$ContinuarButton.disabled = true
	print("Tablero limpiado")

# Función para el botón de "Continuar"
func _on_ContinuarButton_pressed():
	if todos_barcos_colocados():
		print("Todos los barcos colocados. Continuar al siguiente paso.")
		get_tree().change_scene_to_file("res://GameScreen.tscn")
	else:
		print("Aún no todos los barcos están colocados")
