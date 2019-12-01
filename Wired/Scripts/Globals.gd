extends Node

onready var PlayerDamage = 10
onready var PlayerSpeed = 3
onready var PlayerFireRate = 1
onready var PlayerMaxHealth = 100
onready var PlayerHealth = 100
onready var PlayerScore = 0
onready var Wave = 0

onready var MusicPlayer = AudioStreamPlayer.new()

onready var TurretDamage = 20
onready var TurretHealth = 150
onready var TurretFireRate = 1

onready var SfearHealth = 100
onready var SfearDamage = 30
onready var SfearWindup = 2

onready var BGM = preload("res://Sounds/BGM.wav")
onready var ShotFX = preload("res://Sounds/Shoot.wav")
onready var LaserFX = preload("res://Sounds/Laser.wav")

func _ready():
	
	self.add_child(MusicPlayer)
	MusicPlayer.stream = BGM
	MusicPlayer.play()
	
	pass