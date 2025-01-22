extends Node2D

var speed = 500
var direction = Vector2.ZERO 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("basic_projectile node ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	if !get_viewport_rect().has_point(position):
		queue_free()
