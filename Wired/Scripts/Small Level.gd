extends Spatial

onready var UnfilteredArray = self.get_node("GridMap").get_meshes()
onready var CellTransformsArray = Array()
onready var LastType = 0
onready var RoomType
onready var TimeToChangeType

onready var TurretsNode = self.get_node("Turrets")
onready var SFearsNode = self.get_node("SFears")

func _ready():
	
	randomize()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	RoomType = round(rand_range(0, 4))
	TimeToChangeType = round(rand_range(10, 30))
	
	pass
	
func SpawnEnemies():
	
	if(TurretsNode.get_child_count() <= 0 && SFearsNode.get_child_count() <= 0):
		
		Globals.Wave += 1
		
		if(Globals.Wave > 1):
			
			Globals.TurretFireRate += 0.5
			Globals.PlayerMaxHealth = 100 + (50 * Globals.Wave)
			Globals.PlayerHealth = Globals.PlayerMaxHealth
			
		var AmountOfEnemies = (rand_range(2, 8) + 2) + Globals.Wave
		
		if(AmountOfEnemies > 15):
			
			AmountOfEnemies = 15
			
		for Enemy in AmountOfEnemies:
			
			var EnemyToSpawn = round(rand_range(0, 1))
				
			if(EnemyToSpawn == 0):
				
				SpawnTurret()
				
			if(EnemyToSpawn == 1):
				
				SpawnSfear()
				
	pass
	
func SpawnTurret():
	
	var EnemyResource = preload("res://Scenes/Turret.tscn")
	var Enemy = EnemyResource.instance()
	
	TurretsNode.add_child(Enemy)
	
	pass
	
func SpawnSfear():
	
	var EnemyResource = preload("res://Scenes/Mini SFear.tscn")
	var Enemy = EnemyResource.instance()
	
	SFearsNode.add_child(Enemy)
	
	pass
	
func ChangeType():
	
	if(TimeToChangeType > 0):
		
		TimeToChangeType -= get_process_delta_time()
		
	if(TimeToChangeType <= 0):
		
		RoomType = round(rand_range(0, 4))
		TimeToChangeType = round(rand_range(10, 30))
		LastType = 0
		
	pass
	
func ChangeCells():
	
	if(LastType == 0):
		
		for Item in UnfilteredArray:
			
			if(Item is Transform):
				
				CellTransformsArray.append(Item)
				
		for Cell in CellTransformsArray:
			
			var CellPosition = self.get_node("GridMap").world_to_map(Cell.origin)
			
			self.get_node("GridMap").set_cell_item(CellPosition.x, CellPosition.y, CellPosition.z, RoomType)
			
			LastType = 1
	
	pass
	
func TypeHandler():
	
	ChangeType()
	ChangeCells()
	
	pass
	
func _process(delta):
	
	SpawnEnemies()
	TypeHandler()
	
	pass