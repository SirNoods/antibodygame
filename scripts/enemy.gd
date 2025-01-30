extends CharacterBody2D

const RECOIL_TIME = 0.4

var motion = Vector2()
var player_in_range = false
var player = null #refrence the player
var damage = 10 # change for balancing
var health = 100
var movement_speed = 50
var recoil_speed = 40
var is_bullet = false
var recoil_timer = 0.0

@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D

func _ready():
	$progressParent/ProgressBar.value = health
	$Timer.start()

	
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER ENTERED")
		player_in_range = true
		player = body  # Save reference to the player
		
func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER EXITED RANGE")
		#player_in_range = false
		#player = null  # Save reference to the player
		
func _physics_process(delta):
	$progressParent/Label.text = str(health)
	$progressParent.rotation_degrees = 0 - rotation_degrees
	
	"""Behold, Pathfinding Extravaganza"""
	if player_in_range:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		
		velocity = dir * movement_speed
		move_and_slide()
	
	if player_in_range and player !=null:
		pass
		#position += (player.position - position)/50
		#look_at(player.position)
		#var direction = (player.position - position).normalized()
		#if recoil_timer >= 0.0:
			#recoil_timer -= delta
			#print(recoil_timer)
			#direction = (player.position + position).normalized()
			#position += direction * recoil_speed * delta /20
		#else:
			#position += direction * movement_speed * delta
		#move_and_collide(direction)
		
	if health <= 0:
		var player = get_parent().get_parent().get_parent().get_node("player")
		print("killed enemy!")
		player.gain_experience(3)
		queue_free()

func makepath() -> void:
	var player = get_parent().get_parent().get_parent().get_node("player")
	print(player)
	nav_agent.target_position = player.global_position
	print("makepathed " + str(player.global_position))
	
func _on_timer_timeout() -> void:
	if player_in_range:
		makepath()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("ENEMY collided with: "+ body.name)
	if "enemy" in body.name:
		pass
	elif "player" in body.name:
		recoil_timer = RECOIL_TIME
	elif "TileMap" in body.name:
		pass
	else:
		if body.is_bullet:
			print("Enemy shot!")
			health -= (body.damage)
			$progressParent/ProgressBar.value = health
