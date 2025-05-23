extends Node

var volume = 0.5  # Volumen inicial (rango de 0.0 a 1.0)
var is_music_enabled = true  # Controla si la música está habilitada
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	# Añadir dinámicamente el AudioStreamPlayer como hijo
	add_child(audio_player)

	# Cargar la música y configurarla para que se reproduzca en bucle
	var music_stream = preload("res://Sonidos/Fondo.mp3")  # Cambia esta ruta por tu archivo de música
	if music_stream is AudioStream:  # Verificar que es un recurso de audio válido
		audio_player.stream = music_stream
		audio_player.volume_db = linear_to_db(volume)  # Establecer el volumen inicial
		audio_player.play()  # Iniciar la música

func _process(delta):
	# Detectar la tecla "M" para habilitar/deshabilitar la música
	if Input.is_action_just_pressed("ui_music_toggle"):
		is_music_enabled = not is_music_enabled
		if is_music_enabled:
			audio_player.play()
		else:
			audio_player.stop()

	# Detectar las teclas configuradas en Input Map para ajustar el volumen
	if Input.is_action_just_pressed("volumen_subir"):
		cambiar_volumen(0.1)  # Incrementar volumen
	elif Input.is_action_just_pressed("volumen_bajar"):
		cambiar_volumen(-0.1)  # Reducir volumen

func cambiar_volumen(delta):
	volume = clamp(volume + delta, 0.0, 1.0)  # Mantener entre 0.0 y 1.0
	audio_player.volume_db = linear_to_db(volume)  # Convertir a decibelios
	print("Volumen actual:", volume)
