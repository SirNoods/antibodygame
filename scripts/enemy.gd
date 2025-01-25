extends CharacterBody2D

var motion = Vector2()
var player_in_range = false
var player = null #refrence the player

func _ready():
	pass
	
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
	var player = get_parent().get_node("player")
	if player_in_range and player !=null:
		position += (player.position - position)/50
		look_at(player.position)
		move_and_collide(motion)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "bullet" in body.name:
		queue_free()
