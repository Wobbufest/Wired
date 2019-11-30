extends Spatial

onready var MainMenuButton = self.get_node("Button2")
onready var ScoreString = String(Globals.PlayerScore)

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MainMenuButton.connect("pressed", self, "BackToMenu")
	self.get_node("AnimationPlayer").play("New Anim")
	self.get_node("Counter").text = ScoreString
	
	pass
	
func BackToMenu():
	
	self.get_tree().change_scene("res://Scenes/Main Menu.tscn")
	
	pass