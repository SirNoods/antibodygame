extends RigidBody2D

var damage = 15
var is_bullet = true
signal absorbed
@onready var absorbsound: AudioStreamPlayer = $Absorbsound
@onready var deletion_timer: Timer = $DeletionTimer # Add timer to scene
func _ready() -> void:
	print("Bullet loaded")
	var absorbsound: AudioStreamPlayer = $Absorbsound
	
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
		#$Area2D.monitoring = false
		#set_physics_process(false)
		#collision_layer = 0
		#collision_mask = 0
		#hide()
		#play_and_delete()
	else:
		queue_free()
		
func play_and_delete():
	absorbsound.play()
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	visible = false
	deletion_timer.start(absorbsound.stream.get_length())
	
func _on_deletion_timer_timeout():
	queue_free()
