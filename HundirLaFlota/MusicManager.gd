extends Node

var volume = 0.5  # Volumen inicial (rango de 0.0 a 1.0)
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	# Añadir dinámicamente el AudioStreamPlayer como hijo
	add_child(audio_player)

	# Cargar la música y configurarla para que se reproduzca en bucle
	var music_stream = preload("res://Sonidos/Fondo.mp3")  # Cambia esta ruta por tu archivo de música
	if music_stream is AudioStream:
		# Configurar el recurso de audio para que haga bucle
		if music_stream is AudioStreamOggVorbis or music_stream is AudioStreamMP3:
			music_stream.loop = true

		# Asignar el recurso al AudioStreamPlayer
		audio_player.stream = music_stream
		audio_player.volume_db = linear_to_db(volume)  # Establecer el volumen inicial
		audio_player.play()  # Iniciar la música

func _process(delta):
	# Detectar las teclas configuradas en Input Map para ajustar el volumen
	if Input.is_action_just_pressed("volumen_subir"):
		cambiar_volumen(0.1)  # Incrementar volumen
	elif Input.is_action_just_pressed("volumen_bajar"):
		cambiar_volumen(-0.1)  # Reducir volumen

func cambiar_volumen(delta):
	volume = clamp(volume + delta, 0.0, 1.0)  # Mantener entre 0.0 y 1.0
	audio_player.volume_db = linear_to_db(volume)  # Convertir a decibelios
	print("Volumen actual:", volume)
