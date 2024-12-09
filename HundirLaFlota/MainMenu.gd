extends Control

# Referencias a los nodos
@onready var instructions_panel = $InstructionsPanel  # Panel de instrucciones
@onready var audio_player = $AudioStreamPlayer  # Nodo de audio para el sonido

func _ready():
	# Conectar el botón de "Nueva Partida" con la función de comenzar el juego
	$Button.pressed.connect(_on_nueva_partida_pressed)
	
	# Conectar los botones de instrucciones y cerrar
	$InstructionsButton.pressed.connect(_on_instructions_button_pressed)
	$InstructionsPanel/CloseButton.pressed.connect(_on_close_button_pressed)

# Función para cargar la escena de colocación de barcos
func _on_nueva_partida_pressed() -> void:
	if audio_player:  # Verifica que el nodo de audio exista
		audio_player.play()  # Reproducir el sonido
		await audio_player.finished  # Esperar a que termine el sonido antes de cambiar de escena
	get_tree().change_scene_to_file("res://PlaceShips.tscn")

# Función para mostrar el panel de instrucciones
func _on_instructions_button_pressed() -> void:
	instructions_panel.visible = true

# Función para cerrar el panel de instrucciones
func _on_close_button_pressed() -> void:
	instructions_panel.visible = false
