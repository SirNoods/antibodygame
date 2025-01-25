extends RigidBody2D


# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	print("Bullet loaded")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Collision with " + body.name)
	if "enemy" in body.name:
		body.queue_free()
	elif "player" in body.name:
		pass
	else:
		queue_free()
