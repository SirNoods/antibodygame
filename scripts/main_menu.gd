class_name MainMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/start_button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/options_button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button
@onready var start_level = preload("res://scenes/game.tscn") as PackedScene

func _ready():
	pass


func _on_start_button_button_down() -> void:
	print("fuck you I'm not starting yet") # Replace with function body.
	get_tree().change_scene_to_packed(start_level)

func _on_options_button_button_down() -> void:
	print("fuck your chicken strips")

func _on_exit_button_button_down() -> void:
	get_tree().quit()
