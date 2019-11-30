extends Spatial

onready var PlayButton = self.get_node("Button2")

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	InitializeGame()
	self.get_node("AnimationPlayer").play("New Anim")
	PlayButton.connect("pressed", self, "PlayGame")
	
	pass
	
func InitializeGame():
	
	Globals.PlayerDamage = 10
	Globals.PlayerFireRate = 1
	Globals.PlayerMaxHealth = 100
	Globals.PlayerHealth = 100
	Globals.PlayerScore = 0
	Globals.PlayerSpeed = 3
	Globals.Wave = 0
	
	pass
	
func PlayGame():
	
	self.get_tree().change_scene("res://Scenes/Small Level.tscn")
	
	pass