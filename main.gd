extends Node2D

@onready var food = $Food
@onready var snake = $Snake

var grid_size = 32
var game_area = Vector2(640, 480)  # adjust this if your game is a different size

func _ready():
	randomize()
	move_food()
	create_walls()


func move_food():
	var columns = int(game_area.x / grid_size)
	var rows = int(game_area.y / grid_size)

	var snake_positions = $Snake.segments.map(func(s): return $Snake.round_to_grid(s.position))

	var rand_pos := Vector2.ZERO
	while true:
		var rand_x = randi() % columns
		var rand_y = randi() % rows
		rand_pos = Vector2(rand_x, rand_y) * grid_size
		if not rand_pos in snake_positions:
			break

	food.position = rand_pos

	
func create_walls():
	var wall_thickness = 16

	var top_wall = ColorRect.new()
	top_wall.color = Color.WHITE
	top_wall.size = Vector2(game_area.x, wall_thickness)
	top_wall.position = Vector2(0, 0)
	add_child(top_wall)

	var bottom_wall = ColorRect.new()
	bottom_wall.color = Color.WHITE
	bottom_wall.size = Vector2(game_area.x, wall_thickness)
	bottom_wall.position = Vector2(0, game_area.y - wall_thickness)
	add_child(bottom_wall)

	var left_wall = ColorRect.new()
	left_wall.color = Color.WHITE
	left_wall.size = Vector2(wall_thickness, game_area.y)
	left_wall.position = Vector2(0, 0)
	add_child(left_wall)

	var right_wall = ColorRect.new()
	right_wall.color = Color.WHITE
	right_wall.size = Vector2(wall_thickness, game_area.y)
	right_wall.position = Vector2(game_area.x - wall_thickness, 0)
	add_child(right_wall)



func _on_move_timer_timeout() -> void:
	pass # Replace with function body.
