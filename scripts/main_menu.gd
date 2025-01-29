class_name MainMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/start_button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/options_button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button
@onready var start_level = preload("res://scenes/game.tscn") as PackedScene
@onready var options_menu = $options_menu as OptionsMenu

func _ready():
	handle_connecting_signals()

func _on_start_button_button_down() -> void:
	print("Starting Game")
	get_tree().change_scene_to_packed(start_level)

func _on_options_button_button_down() -> void:
	print("Entering Options")
	$MarginContainer.visible = false
	$options_menu.visible = true

func _on_exit_button_button_down() -> void:
	get_tree().quit()
	
func _on_exit_options_menu() -> void:
	$MarginContainer.visible = true
	$options_menu.visible = false
	
func handle_connecting_signals() -> void:
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
