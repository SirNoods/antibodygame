extends RigidBody2D

signal eaten_by_player
signal shot_by_enzyme
var is_bullet = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shot_by_bullet():
	emit_signal("eaten_by_player", self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "player" in body.name or "bullet" in body.name:
		print("BACTERIA DETECTED COLLISION WITH " + body.name)
		emit_signal("eaten_by_player", self)
