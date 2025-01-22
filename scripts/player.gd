extends CharacterBody2D

# Constants
const FLOW_SPEED = 200.0  # Base forward movement speed
const VERTICAL_SPEED = 100.0  # Speed for moving up/down
const HORIZONTAL_ADJUST_SPEED = 100.0  # Speed for left/right adjustments
const DRAG = 0.1  # Simulates fluid drag for vertical movement
const BOOST_SPEED = 500.0  # Speed for dashing
const BOOST_DURATION = 0.3  # Dash lasts for 0.3 seconds

# Variables
var is_boosting = false
var boost_timer = 0.0

# instances
var projectile_scene = preload("res://scenes/basic_projectile.tscn")

func _ready() -> void:
	print("Something")

func _physics_process(delta):
	# Start with a consistent forward speed
	velocity.x = FLOW_SPEED

	# Vertical movement (W/S or Up/Down keys)
	if Input.is_action_pressed("move_up"):
		print("up")
		velocity.y = -VERTICAL_SPEED
	elif Input.is_action_pressed("move_down"):
		print("down")
		velocity.y = VERTICAL_SPEED
	else:
		# Apply drag to vertical movement for a smooth, fluid feel
		velocity.y = lerp(velocity.y, 0.0, DRAG)

	# Horizontal adjustments (A/D or Left/Right keys)
	if Input.is_action_pressed("move_left"):
		print("left")
		velocity.x -= HORIZONTAL_ADJUST_SPEED
	elif Input.is_action_pressed("move_right"):
		print("right")
		velocity.x += HORIZONTAL_ADJUST_SPEED

	# Boost mechanic (Spacebar)
	if Input.is_action_just_pressed("boost") and not is_boosting:
		is_boosting = true
		boost_timer = BOOST_DURATION
		velocity.x = BOOST_SPEED

	if is_boosting:
		boost_timer -= delta
		if boost_timer <= 0:
			is_boosting = false

	# Move the player with the updated velocity
	move_and_slide()
