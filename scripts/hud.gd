extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = (get_parent().get_parent().get_parent().get_node("player"))
	$hplabel.text = "HP: " + str(player.health) + "/100"
	$levellabel.text = str(player.level)
	$currentxplabel.text = str(player.experience)
	$requiredxplabel.text = str(player.experience_required)
	$bulletcooldownlabel.text = str(snapped(player.bullet_cooldown_timer, 0.1))
	
