extends Control


func _ready():
	#Conectar el botón de "Nueva Partida" con la función de comenzar el juego
	$Button.pressed.connect(Callable(self, "_on_nueva_partida_pressed"))


func _on_nueva_partida_pressed():
	#Cargar la escena de colocación de barcos
	get_tree().change_scene_to_file("res://PlaceShips.tscn")
	
