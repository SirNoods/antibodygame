extends CharacterBody2D

# Constants
const BASE_FLOW_SPEED = 100.0  # Base forward movement speed
const PUMP_AMPLITUDE = 50.0
const PUMP_FREQUENCY = 1.0 #bps
const VERTICAL_SPEED = 100.0  # Speed for moving up/down
const HORIZONTAL_ADJUST_SPEED = 150.0  # Speed for left/right adjustments
const LEFT_ADJUST_SPEED = 150.0  # Speed for left/right adjustments
const RIGHT_ADJUST_SPEED = 25.0  # Speed for left/right adjustments
const DRAG = 0.1  # Simulates fluid drag for vertical movement
const BOOST_SPEED = 50000.0  # Speed for dashing
const BOOST_DURATION = 200  # Dash lasts for 2 seconds
const BULLET_COOLDOWN = 0.5

# Variables
var is_boosting = false
var boost_timer = 0.0
var flow_timer = 0.0
var bullet_cooldown_timer = 0.0

# stats
var health = 100
var bullet_speed = 200
var strength = 1.0
var cdr = 1.0

var is_bullet = false

# reference scene


# Leveling System
var level = 1
var experience = 0
var experience_total = 0
var experience_required = 2

func get_required_experience(level):
	return round(pow(level, 1.2) + level * 2)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()

func level_up():
	level +=1
	experience_required = get_required_experience(level + 1)
	var stats = ['health', 'strength', 'cdr', 'bullet_speed']
	heal_max()
	strength += 0.1
	cdr += 0.2
	bullet_speed += 10
	
func heal_max():
	health = 100

# Scene preloading
var bullet = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	print("Player loaded in")
	assert(bullet is PackedScene)

func fire():
	"""
	This is the shooting zone, get ready to slay
	"""
	if bullet_cooldown_timer <= 0.0:
		# Create an instance of the bullet
		var bullet_instance = bullet.instantiate()
		# Offset
		var offset_distance = 12 # adjust as needed
		var offset = Vector2(offset_distance, 0).rotated(rotation)
		# Set the bullet's global position and rotation
		bullet_instance.position = position + offset  # position NOT global position??
		bullet_instance.rotation = rotation  # Use the player's rotation
	
		bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	
	# Add the bullet to the same parent as the player
		get_parent().add_child(bullet_instance)
	bullet_cooldown_timer = BULLET_COOLDOWN/cdr

func kill():
	get_tree().reload_current_scene()


func _physics_process(delta):
	#print(scene.name)
	#$Label.text = "hp "+ str(health) + "str "+ str(strength) + "cdr "+ str(cdr) + "bs "+ str(bullet_speed) + "xp" + str(experience_total)
	look_at(get_global_mouse_position())
	flow_timer += delta
	var flow_variation = sin(flow_timer * PUMP_FREQUENCY * TAU) * scale_movement(PUMP_AMPLITUDE)
	velocity.x = scale_movement(BASE_FLOW_SPEED) + flow_variation
	
	# Vertical movement (W/S or Up/Down keys)
	if Input.is_action_pressed("move_up"):
		velocity.y = -scale_movement(VERTICAL_SPEED)
	elif Input.is_action_pressed("move_down"):
		velocity.y = scale_movement(VERTICAL_SPEED)
	else:
		# Apply drag to vertical movement
		velocity.y = lerp(velocity.y, 0.0, DRAG)

	# Horizontal adjustments (A/D or Left/Right keys)
	if Input.is_action_pressed("move_left"):
		velocity.x -= LEFT_ADJUST_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x += scale_movement(RIGHT_ADJUST_SPEED)

	# Boost mechanic (Spacebar)
	if Input.is_action_just_pressed("boost") and not is_boosting:
		is_boosting = true
		boost_timer = BOOST_DURATION
		velocity.x = BOOST_SPEED
	
	if Input.is_action_just_pressed("shoot"):
		if bullet_cooldown_timer <= 0.0:
			print("pew")
			fire()
		else:
			print("Cooldown!")
	
	if bullet_cooldown_timer > 0.0:
		bullet_cooldown_timer -= delta
	
	if is_boosting:
		boost_timer -= delta
		if boost_timer <= 0:
			is_boosting = false
	
	if health <= 0:
		kill()

	# Move the player with the updated velocity
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		if health > 0:
			health -= body.damage
	if "@RigidBody" in body.name:
		if health < 100:
			health +=2
			gain_experience(1)

func scale_movement(base_speed: float) -> float:
	# Get all movement areas
	var areas = get_tree().get_nodes_in_group("movement_areas")
	
	# Track the strongest (highest) speed modifier
	var max_modifier = 1.0  # Default is normal speed

	for area in areas:
		if area is Area2D and area.overlaps_body(self):
			#print(area.name)
			var modifier = 1.0  # Default to no change
			
			# Determine modifier based on area name
			if "superslow" in area.name:
				modifier = 0.5
			elif "slow" in area.name:
				modifier = 0.75
			elif "normal" in area.name:
				modifier = 1.0
			elif "fast" in area.name:
				modifier = 1.5
			elif "superfast" in area.name:
				modifier = 2.0
			
			# Keep only the highest modifier encountered
			max_modifier = max(max_modifier, modifier)

	return base_speed * max_modifier
	
