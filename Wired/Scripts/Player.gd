extends KinematicBody

onready var UpAimLimiter = self.get_node("Up Limiter")
onready var DownAimLimiter = self.get_node("Down Limiter")
onready var AimPivot = self.get_node("Up-Down Pivot")
onready var LeftCannon = self.get_node("Up-Down Pivot/Left")
onready var RightCannon = self.get_node("Up-Down Pivot/Right")
onready var LeftNozzle = self.get_node("Up-Down Pivot/Left/Nozzle")
onready var RightNozzle = self.get_node("Up-Down Pivot/Right/Nozzle")
onready var Counter = self.get_node("Up-Down Pivot/Camera/Counter")

onready var MinutesLeft = 15
onready var SecondsLeft = 0

onready var TimeToShake = 0
onready var Shaking = false

onready var WPressed = false
onready var SPressed = false
onready var APressed = false
onready var DPressed = false
onready var Clicking = false
onready var ShiftPressed = false
onready var ShiftPressing = false
onready var SpacePressed = false

onready var Dashing = false
onready var DashType = 0
onready var DashTime = 0.25
onready var DashCooldown = 2

onready var Jumping = false
onready var YVel = 0

onready var XSpeed = 0
onready var ZSpeed = 0

onready var UpDownLevel = 0.5
onready var Sens = 0.15
onready var MoveSpeed = Globals.PlayerSpeed
onready var ShotCooldown = 0
onready var FireRate = Globals.PlayerFireRate

func TimerHandler():
	
	if(SecondsLeft < 0):
		
		if(MinutesLeft <= 0):
			
			self.get_tree().change_scene("res://Scenes/Game Over.tscn")
		
		if(MinutesLeft > 0):
			
			MinutesLeft -= 1
			SecondsLeft = 59
			
	if(SecondsLeft >= 0):
		
		SecondsLeft -= get_physics_process_delta_time()
		
	var Seconds
	var Minutes
	
	if(round(SecondsLeft) > 9):
		
		Seconds = String(round(SecondsLeft))
		
	elif(round(SecondsLeft) >= 0):
		
		Seconds = String("0" + String(round(SecondsLeft)))
		
	else:
		
		Seconds = "00"
		
	if(round(MinutesLeft) > 9):
		
		Minutes = String(round(MinutesLeft))
		
	else:
		
		Minutes = String("0" + String(round(MinutesLeft)))
	
	self.get_node("Up-Down Pivot/Camera/Timer").text = String(Minutes + ":" + Seconds)
	
	pass

func PowerUpHandler():
	
	if(Globals.PlayerScore < 3000):
		
		Globals.PlayerDamage = 30
		Globals.PlayerSpeed = 3
		Globals.PlayerFireRate = 1
		
	elif(Globals.PlayerScore >= 3000):
		
		Globals.PlayerDamage = 50
		Globals.PlayerSpeed = 5
		Globals.PlayerFireRate = 2
		
	elif(Globals.PlayerScore >= 7500):
		
		Globals.PlayerDamage = 80
		Globals.PlayerSpeed = 6
		Globals.PlayerFireRate = 3
		
	elif(Globals.PlayerScore >= 15000):
		
		Globals.PlayerDamage = 110
		Globals.PlayerSpeed = 6
		Globals.PlayerFireRate = 4
		
	pass
	
func StatsHandler():
	
	FireRate = Globals.PlayerFireRate
	MoveSpeed = Globals.PlayerSpeed
	
	pass
	
func DeathHandler():
	
	if(Globals.PlayerHealth <= 0):
		
		self.get_tree().change_scene("res://Scenes/Game Over.tscn")
		
	pass
	
func TakeDamage(Damage):
	
	Globals.PlayerHealth -= Damage
	Shaking = true
	TimeToShake = 0.25
	self.get_node("SFX").stream = Globals.ShotFX
	self.get_node("SFX").play()
	
	pass

func AimChange(XSpeed, YSpeed):
	
	self.rotate(Vector3(0, 1, 0), -deg2rad(XSpeed) * Sens)
	
	UpDownLevel -= deg2rad(YSpeed) * Sens
	
	if(UpDownLevel >= 1):
		
		UpDownLevel = 1
		
	if(UpDownLevel <= 0):
		
		UpDownLevel = 0
	
	pass
	
func AimHandler():
	
	AimPivot.transform = DownAimLimiter.transform.interpolate_with(UpAimLimiter.transform, UpDownLevel)
	
	pass
	
func _input(event):
	
	if(event is InputEventMouseMotion):
		
		AimChange(event.relative.x, event.relative.y)
		
	if(event is InputEventMouseButton):
		
		if(event.button_index == BUTTON_LEFT && event.is_pressed()):
			
			Clicking = true
			
		if(event.button_index == BUTTON_LEFT && !event.is_pressed()):
			
			Clicking = false
			
	if(event is InputEventKey):
		
		if(event.scancode == KEY_W && event.is_pressed()):
			
			WPressed = true
			
		if(event.scancode == KEY_W && !event.is_pressed()):
			
			WPressed = false
			
		if(event.scancode == KEY_S && event.is_pressed()):
			
			SPressed = true
			
		if(event.scancode == KEY_S && !event.is_pressed()):
			
			SPressed = false
			
		if(event.scancode == KEY_A && event.is_pressed()):
			
			APressed = true
			
		if(event.scancode == KEY_A && !event.is_pressed()):
			
			APressed = false
			
		if(event.scancode == KEY_D && event.is_pressed()):
			
			DPressed = true
			
		if(event.scancode == KEY_D && !event.is_pressed()):
			
			DPressed = false
			
		if(event.scancode == KEY_SHIFT && event.is_pressed()):
			
			ShiftPressed = true
			
		if(event.scancode == KEY_SHIFT && !event.is_pressed()):
			
			ShiftPressed = false
			ShiftPressing = false
			
		if(event.scancode == KEY_SPACE && event.is_pressed()):
			
			SpacePressed = true
			
		if(event.scancode == KEY_SPACE && !event.is_pressed()):
			
			SpacePressed = false
			
	pass
	
func Shoot():
	
	var BulletResource = preload("res://Scenes/Bullet.tscn")
	
	var BulletA = BulletResource.instance()
	var BulletB = BulletResource.instance()
	
	self.get_tree().current_scene.add_child(BulletA)
	self.get_tree().current_scene.add_child(BulletB)
	
	BulletA.transform = LeftNozzle.get_global_transform()
	BulletB.transform = RightNozzle.get_global_transform()
	
	self.get_node("SFX2").stream = Globals.LaserFX
	self.get_node("SFX2").play()
	
	pass
	
func CameraShakeHandler():
	
	if(Shaking):
		
		TimeToShake -= get_physics_process_delta_time()
		
		if(TimeToShake > 0):
			
			self.get_node("Up-Down Pivot/Camera").h_offset = rand_range(0, 0.05)
			self.get_node("Up-Down Pivot/Camera").v_offset = rand_range(0, 0.05)
			
		if(TimeToShake <= 0):
			
			Shaking = false
			
	if(!Shaking):
		
		self.get_node("Up-Down Pivot/Camera").h_offset = 0
		self.get_node("Up-Down Pivot/Camera").v_offset = 0
		
	pass
	
func ShootingHandler():
	
	if(ShotCooldown <= 0 && Clicking):
		
		Shoot()
		Clicking = true
		ShotCooldown = 1
		
	if(ShotCooldown > 0):
		
		ShotCooldown -= get_physics_process_delta_time() * FireRate
	
	pass
	
func DashHandler():
	
	if(!Dashing && DashCooldown > 0):
		
		DashCooldown -= get_physics_process_delta_time()
		
	if(ShiftPressed && !ShiftPressing && DashCooldown <= 0):
		
		DashTime = 0.25
		DashCooldown = 2
		Dashing = true
		
		if(WPressed):
			
			if(APressed):
				
				DashType = 7
				
			if(DPressed):
				
				DashType = 1
				
			if(!APressed && !DPressed || APressed && DPressed):
				
				DashType = 0
				
		if(SPressed):
			
			if(APressed):
				
				DashType = 5
				
			if(DPressed):
				
				DashType = 3
				
			if(!APressed && !DPressed || APressed && DPressed):
				
				DashType = 4
				
		if(APressed && !WPressed && !SPressed):
			
			DashType = 6
			
		if(DPressed && !WPressed && !SPressed):
			
			DashType = 2
			
	if(Dashing):
		
		DashTime -= get_physics_process_delta_time()
		
		match(DashType):
			
			0:
				
				self.move_and_slide(self.transform.basis.z * -(MoveSpeed * 4), Vector3(0, 1, 0))
				
			1:
				
				self.move_and_slide(self.transform.basis.z * -(MoveSpeed * 4), Vector3(0, 1, 0))
				self.move_and_slide(self.transform.basis.x * (MoveSpeed * 4), Vector3(0, 1, 0))
				
			2:
				
				self.move_and_slide(self.transform.basis.x * (MoveSpeed * 4), Vector3(0, 1, 0))
				
			3:
				
				self.move_and_slide(self.transform.basis.z * (MoveSpeed * 4), Vector3(0, 1, 0))
				self.move_and_slide(self.transform.basis.x * (MoveSpeed * 4), Vector3(0, 1, 0))
				
			4:
				
				self.move_and_slide(self.transform.basis.z * (MoveSpeed * 4), Vector3(0, 1, 0))
				
			5:
				
				self.move_and_slide(self.transform.basis.z * (MoveSpeed * 4), Vector3(0, 1, 0))
				self.move_and_slide(self.transform.basis.x * -(MoveSpeed * 4), Vector3(0, 1, 0))
				
			6:
				
				self.move_and_slide(self.transform.basis.x * -(MoveSpeed * 4), Vector3(0, 1, 0))
				
			7:
				
				self.move_and_slide(self.transform.basis.z * -(MoveSpeed * 4), Vector3(0, 1, 0))
				self.move_and_slide(self.transform.basis.x * -(MoveSpeed * 4), Vector3(0, 1, 0))
				
	if(DashTime <= 0):
		
		Dashing = false
		DashTime = 0
		
	pass
	
func JumpHandler():
	
	YVel -= 1
		
	if(SpacePressed && self.is_on_floor()):
		
		Jump()
		
	if(self.is_on_ceiling()):
		
		YVel = 0
		
	self.move_and_slide(Vector3(0, YVel, 0), Vector3(0, 1, 0))
	
	pass
	
func Jump():
	
	if(Globals.PlayerScore < 5000):
		
		YVel = 15
		
	elif(Globals.PlayerScore >= 5000):
		
		YVel = 20
		
	elif(Globals.PlayerScore >= 10000):
		
		YVel = 30
		
	elif(Globals.PlayerScore >= 20000):
		
		YVel = 50
	
	pass
	
func MovementHandler():
	
	if(WPressed):
		
		self.move_and_slide(self.transform.basis.z * -MoveSpeed, Vector3(0, 1, 0))
		
	if(SPressed):
		
		self.move_and_slide(self.transform.basis.z * MoveSpeed, Vector3(0, 1, 0))
		
	if(APressed):
		
		self.move_and_slide(self.transform.basis.x * -MoveSpeed, Vector3(0, 1, 0))
		
	if(DPressed):
		
		self.move_and_slide(self.transform.basis.x * MoveSpeed, Vector3(0, 1, 0))
		
	self.move_and_slide(self.transform.basis.y * -1, Vector3(0, 1, 0))
	
	pass
	
func HealthHandler():
	
	self.get_node("Up-Down Pivot/Camera/ProgressBar").max_value = Globals.PlayerMaxHealth
	self.get_node("Up-Down Pivot/Camera/ProgressBar").value = Globals.PlayerHealth
	
	pass
	
func _physics_process(delta):
	
	DashHandler()
	JumpHandler()
	ShootingHandler()
	PowerUpHandler()
	HealthHandler()
	CameraShakeHandler()
	TimerHandler()
	
	if(!Dashing):
		
		MovementHandler()
		
	pass
	
func _process(delta):
	
	AimHandler()
	StatsHandler()
	DeathHandler()
	
	Counter.text = String(Globals.PlayerScore)
	
	pass