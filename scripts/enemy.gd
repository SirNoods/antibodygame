extends CharacterBody2D

const RECOIL_TIME = 0.4

var motion = Vector2()
var player_in_range = false
var player = null #refrence the player
var damage = 10 # change for balancing
var health = 100
var movement_speed = 20
var recoil_speed = 40
var is_bullet = false
var recoil_timer = 0.0


func _ready():
	$progressParent/ProgressBar.value = health

	
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER ENTERED")
		player_in_range = true
		player = body  # Save reference to the player
		
func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER EXITED")
		player_in_range = false
		player = null  # Save reference to the player
		
func _physics_process(delta):
	$progressParent/Label.text = str(health)
	$progressParent.rotation_degrees = 0 - rotation_degrees
	
	
	var player = get_parent().get_node("player")
	if player_in_range and player !=null:
		#position += (player.position - position)/50
		look_at(player.position)
		var direction = (player.position - position).normalized()
		if recoil_timer >= 0.0:
			recoil_timer -= delta
			print(recoil_timer)
			direction = (player.position + position).normalized()
			position += direction * recoil_speed * delta /20
		else:
			position += direction * movement_speed * delta
		move_and_collide(direction)
		if health <= 0:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("ENEMY collided with: "+ body.name)
	if "enemy" in body.name:
		pass
	elif "player" in body.name:
		recoil_timer = RECOIL_TIME
	else:
		if body.is_bullet:
			print("Enemy shot!")
			health -= (body.damage)
			$progressParent/ProgressBar.value = health
