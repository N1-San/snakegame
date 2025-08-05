extends Node2D

@onready var food = $Food
@onready var snake = $Snake

var grid_size = 32
var game_area = Vector2(640, 480)  # adjust this if your game is a different size

func _ready():
	randomize()
	move_food()

func move_food():
	var columns = int(game_area.x / grid_size)
	var rows = int(game_area.y / grid_size)
	var rand_x = randi() % columns
	var rand_y = randi() % rows
	food.position = Vector2(rand_x, rand_y) * grid_size


func _on_move_timer_timeout() -> void:
	pass # Replace with function body.
