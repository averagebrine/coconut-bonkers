extends Node2D

onready var player = $Bob
onready var nav = $Navigation2D

get_tree().call_group("Enemy", 'get_target_path', player.global_position)
