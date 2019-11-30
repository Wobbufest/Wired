extends Spatial

onready var Shooting = false
onready var Moving = false
onready var Direction = 0
onready var MovementDuration = 0
onready var TimeToRotate = 0
onready var Rotation = 0
onready var TimeShooting = 0
onready var Health = Globals.TurretHealth + (Globals.TurretHealth * (Globals.Wave / 2))

onready var Turret = self.get_node("Movement Pivot/UpDown Pivot/Turret")
onready var TurretAim = self.get_node("Movement Pivot/UpDown Pivot/Aim")
onready var TurretNozzle = self.get_node("Movement Pivot/UpDown Pivot/Turret/Nozzle")
onready var MovementPivot = self.get_node("Movement Pivot")
onready var UpDownPivot = self.get_node("Movement Pivot/UpDown Pivot")

onready var FireRate = Globals.TurretFireRate
onready var FireCooldown = 1

onready var Target

func _ready():
	
	randomize()
	SetPosition()
	UpDownPivot.rotate(Vector3(1, 0, 0), deg2rad(rand_range(-15, 15)))
	MovementPivot.rotate(Vector3(0, 1, 0), deg2rad(rand_range(0, 360)))
	
	pass
	
func TakeDamage():
	
	Health -= Globals.PlayerDamage
	
	pass
	
func HealthHandler():
	
	if(Health <= 0):
		
		Globals.PlayerScore += 400 + (round(rand_range(0, 10)) * Globals.Wave)
		self.queue_free()
		
	pass
	
func SetPosition():
	
	if(self.get_parent().is_in_group("Turret Holder")):
		
		var MyNumber = self.get_index()
		var Start = rand_range(2, 4)
		
		Turret.translation.z = -(Start + MyNumber)
		TurretAim.translation.z = -(Start + MyNumber)
		
	pass
	
func BehaviorHandler(delta):
	
	AimHandler(delta)
	
	if(!Shooting && !Moving):
		
		var NextAction = round(rand_range(0, 1))
		
		if(NextAction == 0):
			
			Moving = true
			MovementDuration = rand_range(2, 10)
			Direction = round(rand_range(-1, 1))
			TimeToRotate = MovementDuration
			Rotation = deg2rad(rand_range(0, 360))
			Moving = true
			
		if(NextAction == 1):
			
			Shooting = true
			TimeShooting = rand_range(5, 10)
			
	if(Shooting):
		
		ShootingHandler()
		
	if(Moving):
		
		MovementHandler()
		
	pass
	
func MovementHandler():
	
	if(Moving):
		
		Shooting = false
		
		if(MovementDuration > 0):
			
			MovementDuration -= get_physics_process_delta_time()
			
			if(Direction > 0):
				
				MovementPivot.rotate(Vector3(0, 1, 0), Rotation * (get_physics_process_delta_time() / TimeToRotate))
				
			if(Direction < 0):
				
				MovementPivot.rotate(Vector3(0, 1, 0), Rotation * (get_physics_process_delta_time() / TimeToRotate))
				
		if(MovementDuration <= 0):
			
			MovementDuration = 0
			Moving = false
			Direction = 0
			
	pass
	
func Fire():
	
	var BulletResource = preload("res://Scenes/Turret Bullet.tscn")
	var Bullet = BulletResource.instance()
	
	self.get_tree().current_scene.add_child(Bullet)
	Bullet.transform = TurretNozzle.get_global_transform()
	
	pass
	
func ShootingHandler():
	
	if(TimeShooting > 0):
		
		if(FireCooldown <= 0):
			
			Fire()
			FireCooldown = 1
			
		if(FireCooldown > 0):
			
			FireCooldown -= FireRate * get_physics_process_delta_time()
			
		TimeShooting -= get_physics_process_delta_time()
		
	if(TimeShooting <= 0):
		
		Shooting = false
		TimeShooting = 0
		
	pass

func TargetHandler():
	
	var SceneChildren = self.get_tree().current_scene.get_children()
	
	for TNode in SceneChildren:
		
		if(TNode.is_in_group("Player")):
			
			Target = TNode
			break
			
	pass

func AimHandler(delta):
	
	if(Target != null):
		
		TurretAim.look_at(Target.transform.origin, Vector3(0, 1, 0))
		
	Turret.transform = Turret.transform.interpolate_with(TurretAim.transform, delta)
	
	pass

func _physics_process(delta):
	
	BehaviorHandler(delta)
	TargetHandler()
	HealthHandler()
	
	pass