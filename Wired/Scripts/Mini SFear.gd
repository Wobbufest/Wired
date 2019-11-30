extends Spatial

onready var Sfear = self.get_node("SFear")

onready var Target
onready var Locked = false
onready var WindingUp = false
onready var Dashing = false
onready var DashTime = 3
onready var WindUpTime = Globals.SfearWindup
onready var Health = Globals.SfearHealth
onready var Damage = Globals.SfearDamage

onready var PlayerInside = false

onready var Velocity = 0.05

func _ready():
	
	randomize()
	SetPosition()
	
	Sfear.connect("body_entered", self, "DealDamage")
	
	pass
	
func DealDamage(Body):
	
	if(Body.is_in_group("Player")):
		
		Body.TakeDamage(4 + Globals.Wave)
		
	pass
	
func SetPosition():
	
	var Radius = rand_range(2, 8)
	var Angle = rand_range(0, 360)
	
	self.rotate(Vector3(0, 1, 0), deg2rad(Angle))
	
	Sfear.translation.z = Radius
	
	pass
	
func TargetHandler():
	
	for TNode in self.get_tree().current_scene.get_children():
		
		if(TNode.is_in_group("Player") && !Locked):
			
			Target = TNode
			Locked = true
			break
	
	pass
	
func FaceTarget():
	
	if(Target != null):
		
		if(Target.is_in_group("Player")):
			
			Sfear.look_at(Vector3(Target.transform.origin.x, Sfear.transform.origin.y, Target.transform.origin.z), Vector3(0, 1, 0))
			
	pass
	
func BehaviorHandler():
	
	if(!Locked && !Dashing && !WindingUp):
		
		TargetHandler()
		
	if(Locked):
		
		if(!Dashing):
			
			if(!WindingUp):
				
				WindingUp = true
				
			if(WindingUp):
				
				if(!Dashing):
					
					if(WindUpTime > 0):
						
						WindUpTime -= get_physics_process_delta_time()
						
					if(WindUpTime <= 0):
						
						FaceTarget()
						WindingUp = false
						WindUpTime = 3
						Dashing = true
						Sfear.angular_velocity = Sfear.get_global_transform().basis.x.rotated(Vector3(0, 1, 0), deg2rad(rand_range(-45, 45))) * -100
						
		if(Dashing):
			
			if(DashTime > 0):
				
				DashTime -= get_physics_process_delta_time()
				
			if(DashTime <= 0):
				
				DashTime = 3
				Dashing = false
				Locked = false
				Sfear.linear_velocity = Vector3(0, 0, 0)
				Sfear.angular_velocity = Vector3(0, 0, 0)
			
	pass
	
func TakeDamage():
	
	Health -= Globals.PlayerDamage
	
	pass
	
func HealthHandler():
	
	if(Health <= 0):
		
		Globals.PlayerScore += 250 + (round(rand_range(0, 10)) * Globals.Wave)
		self.queue_free()
		
	pass
	
func _physics_process(delta):
	
	BehaviorHandler()
	HealthHandler()
	
	pass