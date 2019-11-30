extends KinematicBody

onready var Trigger = self.get_node("Area")
onready var Speed

func _ready():
	
	SpeedHandler()
	
	pass

func _physics_process(delta):
	
	self.move_and_slide(self.transform.basis.z * -Speed, Vector3(0, 1, 0))
	TriggerHandler()
	
	pass
	
func SpeedHandler():
	
	if(Globals.PlayerScore < 5000):
		
		Speed = 10
		
	elif(Globals.PlayerScore >= 5000):
		
		Speed = 15
		
	elif(Globals.PlayerScore >= 10000):
		
		Speed = 20
		
	elif(Globals.PlayerScore >= 20000):
		
		Speed = 30
		
	pass
	
func TriggerHandler():
	
	for Collider in Trigger.get_overlapping_bodies():
		
		if(Collider.is_in_group("Enemy")):
			
			if(Collider.is_in_group("Turret")):
				
				Collider.get_parent().get_parent().get_parent().TakeDamage()
				self.queue_free()
				
			if(Collider.is_in_group("SFear")):
				
				Collider.get_parent().TakeDamage()
				self.queue_free()
				
		if(Collider is StaticBody):
			
			self.queue_free()
	pass