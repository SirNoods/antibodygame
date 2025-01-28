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
var bullet_speed = 200
var flow_timer = 0.0
var bullet_cooldown_timer = 0.0
var health = 100
var is_bullet = false

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
	bullet_cooldown_timer = BULLET_COOLDOWN

func kill():
	get_tree().reload_current_scene()


func _physics_process(delta):
	$Label.text = str(health)
	look_at(get_global_mouse_position())
	flow_timer += delta
	var flow_variation = sin(flow_timer * PUMP_FREQUENCY * TAU) * PUMP_AMPLITUDE
	velocity.x = BASE_FLOW_SPEED + flow_variation
	
	# Vertical movement (W/S or Up/Down keys)
	if Input.is_action_pressed("move_up"):
		velocity.y = -VERTICAL_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity.y = VERTICAL_SPEED
	else:
		# Apply drag to vertical movement
		velocity.y = lerp(velocity.y, 0.0, DRAG)

	# Horizontal adjustments (A/D or Left/Right keys)
	if Input.is_action_pressed("move_left"):
		velocity.x -= LEFT_ADJUST_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x += RIGHT_ADJUST_SPEED

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
			health +=1
