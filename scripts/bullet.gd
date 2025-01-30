extends RigidBody2D

var damage = 15
var is_bullet = true

func _ready() -> void:
	print("Bullet loaded")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_velocity() -> Vector2:
	return linear_velocity


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("BULLET: Collision with " + body.name)
	if "enemy" in body.name:
		var player = get_parent().get_node("player")
		damage = damage*player.strength
		call_deferred("queue_free")
	elif "player" in body.name:
		pass
	elif "RigidBody2D" in body.name:
		print("BULLET DETECTED BACTERIUM")
		body.shot_by_bullet()
		call_deferred("queue_free")
		
	elif "TileMapLayer" in body.name:
		queue_free()
		var player = get_parent().get_node("player")
		if player:
			#player.kill()
			pass
	else:
		queue_free()
