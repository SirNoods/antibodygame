extends CharacterBody2D

# Constants
const FLOW_SPEED = 50.0  # Base forward movement speed
const VERTICAL_SPEED = 100.0  # Speed for moving up/down
const HORIZONTAL_ADJUST_SPEED = 100.0  # Speed for left/right adjustments
const DRAG = 0.1  # Simulates fluid drag for vertical movement
const BOOST_SPEED = 5000.0  # Speed for dashing
const BOOST_DURATION = 2  # Dash lasts for 2 seconds

# Variables
var is_boosting = false
var boost_timer = 0.0
var bullet_speed = 100

# Scene preloading
var bullet = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	print("Player loaded in")
	assert(bullet is PackedScene)

func fire():
	# Create an instance of the bullet
	var bullet_instance = bullet.instantiate()
	# Offset
	var offset_distance = 10 # adjust as needed
	var offset = Vector2(offset_distance, 0).rotated(rotation)
	# Set the bullet's global position and rotation
	bullet_instance.position = position + offset  # position NOT global position??
	bullet_instance.rotation = rotation  # Use the player's rotation
	
	bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	
	# Add the bullet to the same parent as the player
	get_parent().add_child(bullet_instance)


func _physics_process(delta):
	look_at(get_global_mouse_position())
	# Start with a consistent forward speed
	velocity.x = FLOW_SPEED
	
	# Vertical movement (W/S or Up/Down keys)
	if Input.is_action_pressed("move_up"):
		velocity.y = -VERTICAL_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity.y = VERTICAL_SPEED
	else:
		# Apply drag to vertical movement for a smooth, fluid feel
		velocity.y = lerp(velocity.y, 0.0, DRAG)

	# Horizontal adjustments (A/D or Left/Right keys)
	if Input.is_action_pressed("move_left"):
		velocity.x -= HORIZONTAL_ADJUST_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x += HORIZONTAL_ADJUST_SPEED

	# Boost mechanic (Spacebar)
	if Input.is_action_just_pressed("boost") and not is_boosting:
		is_boosting = true
		boost_timer = BOOST_DURATION
		velocity.x = BOOST_SPEED
	
	if Input.is_action_pressed("shoot"): # turn into is_action_just_pressed to get rid of the constant fire!!
		print("pew")
		fire()
	
	if is_boosting:
		boost_timer -= delta
		if boost_timer <= 0:
			is_boosting = false

	# Move the player with the updated velocity
	move_and_slide()
