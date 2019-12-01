extends KinematicBody

onready var PlayersCollided = Array()
onready var WallsCollided = 0

onready var Trigger = self.get_node("Area")

func _physics_process(delta):
	
	self.move_and_slide(self.transform.basis.z * -5, Vector3(0, 1, 0))
	
	for Collider in Trigger.get_overlapping_bodies():
		
		if(Collider.is_in_group("Player")):
			
			if(PlayersCollided.find(Collider, 0) == -1):
				
				PlayersCollided.append(Collider)
				Collider.TakeDamage(10 * Globals.Wave)
				self.queue_free()
				
		if(Collider is StaticBody):
			
			WallsCollided += 1
			
	if(WallsCollided > 0):
		
		self.queue_free()
		
	pass