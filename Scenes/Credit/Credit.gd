extends Control


@onready var credit_label: Label = $CreditLabel
var speed: float = 40.0  # pixel al secondo


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"):
		GameManager.set_mode("menu")


func _ready():
	credit_label.text = """
	Snake
	
	
	
	
	Credit
	
	
	Programmer
	
	Valentin Cristian Ghita (aka CoderArtist06)
	
	
	Artist
	
	Valentin Cristian Ghita (aka CoderArtist06)
	
	
	
	
	Third-Party Resources
	
	
	Font
	
	The Tiny5 Project 
	Authors (https://github.com/Gissio/font_tiny5)
	licensed under 
	SIL Open Font License, Version 1.1
	
	
	SFX
	
	(empty)
	
	
	Music
	
	(empty)
	
	
	
	
	Special Thanks
	
	A special thanks to "Snake", 
	the game that defined my childhood. 
	I spent countless hours playing it on 
	my mom’s iconic Nokia 3310, chasing pixels 
	and breaking my own records. 
	It was my very first encounter with video games, 
	and it left me with one of the most 
	cherished memories I have from that time.
	
	
	
	thank you all for playing my game 
	- CoderArtist06
	
	
	
	
	
	The video game is licensed under 
	GPL-3.0.
	"""
	
	# Posiziona il testo sotto lo schermo
	credit_label.position.y = size.y


func _process(delta):
	credit_label.position.y -= speed * delta
	# Rimuove il nodo quando è completamente fuori dallo schermo
	if credit_label.position.y + credit_label.size.y < -48:
		credit_label.queue_free()
		GameManager.set_mode("menu")
