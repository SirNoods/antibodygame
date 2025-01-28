extends Node2D

var swarm_size = 10 # number of bacteria
var spawn_radius = 50.0
var bacteria_scene = preload("res://scenes/bacteria2.tscn")
var movement_speed = 2.0
var follow_distance = 100.0
var is_bullet = false
var bacteria_list: Array[Node2D] = []

var player = null #refrence the player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Swarm entered")
	spawn_swarm()

func spawn_swarm() -> void:
	for i in range(swarm_size):
		var bacteria_instance = bacteria_scene.instantiate()
		if bacteria_instance:
			print("Bacteria instance created:", i)
		bacteria_instance.position = position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
		bacteria_list.append(bacteria_instance)
		add_child(bacteria_instance)  # Add the bacteria as a child of the swarm
		bacteria_instance.connect("eaten_by_player", Callable(self, "_on_bacteria_eaten"))
		bacteria_instance.connect("shot_by_enzyme", Callable(self, "_on_bacteria_shot"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_swarm(delta)
	apply_repulsion(delta)
	

func move_swarm(delta: float) -> void:
	for bacteria in bacteria_list:
		# each bacteria moves slightly randomly within the swarm's radius
		var random_offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * movement_speed * delta
		bacteria.global_position += random_offset
		if player:
			var player_pos = player.position
			bacteria.look_at(player_pos)
			move_swarm_towards_player(delta, player_pos)

func move_swarm_towards_player(delta: float, player_pos: Vector2) -> void:
	for bacteria in bacteria_list:
		if bacteria:
			var direction = (player_pos - bacteria.global_position).normalized()
			bacteria.position += direction * movement_speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER ENTERED")
		player = body  # Save reference to the player



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":  # Check if the body is the player
		print("PLAYER EXITED")
		player = null  # Save reference to the player
		

func apply_repulsion(delta: float) -> void:
	for bacteria_a in bacteria_list:
		for bacteria_b in bacteria_list:
			if bacteria_a == bacteria_b or bacteria_a == null or bacteria_b == null:
				continue
			var distance = bacteria_a.global_position.distance_to(bacteria_b.global_position)
			if distance < spawn_radius / 2: # repulsion only at close distance
				var direction = (bacteria_a.global_position - bacteria_b.global_position).normalized()
				bacteria_a.position += direction * movement_speed * delta * 0.5 #adjust repulsion strength as needed

func _on_bacteria_eaten(bacteria):
	print("SWARM CONTROLLER - CALLED EATING FUNCTION " + str(bacteria))
	bacteria_list.erase(bacteria)
	bacteria.queue_free()
	# perform actions like healing or something

func _on_bacteria_shot(bacteria):
	if bacteria in bacteria_list:
		bacteria_list.erase(bacteria)
		bacteria.queue_free()
	print("Bacteria shot!")
