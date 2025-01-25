extends CharacterBody2D

var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	var player = get_parent().get_node("player")
	position += (player.position - position)/50
	look_at(player.position)
	move_and_collide(motion)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "bullet" in body.name:
		queue_free()
