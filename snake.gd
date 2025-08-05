extends Node2D

var direction = Vector2.RIGHT
var segment_size = 32
var segments = []
var game_area = Vector2(640, 480) # Change this if your screen is different

func _ready():
	spawn_snake()
	set_process(true) # ← add this

func round_to_grid(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x), round(pos.y))

func spawn_snake():
	var head = ColorRect.new()
	head.color = Color(0.0, 0.6, 0.0) # darker green
	head.size = Vector2(segment_size, segment_size)
	head.position = round_to_grid(Vector2(160, 160))
	add_child(head)
	segments.append(head)

func move():
	var new_head_pos = round_to_grid(segments[0].position + direction * segment_size)

	# Wall collision
	if new_head_pos.x < 0 or new_head_pos.x >= game_area.x \
		or new_head_pos.y < 0 or new_head_pos.y >= game_area.y:
		game_over("wall")
		return

	# Self-collision
	for segment in segments:
		if round_to_grid(segment.position) == new_head_pos:
			game_over("self")
			return

	# Reset previous head color to body color
	if segments.size() > 0:
		segments[0].color = Color(0.2, 0.8, 0.3)  # lighter green

	# Add new head
	var new_head = ColorRect.new()
	new_head.color = Color(0.0, 0.6, 0.0) # darker green
	new_head.size = Vector2(segment_size, segment_size)
	new_head.position = new_head_pos
	add_child(new_head)
	segments.insert(0, new_head)

	# Food collision
	var food_pos = round_to_grid(get_parent().get_node("Food").position)
	if new_head_pos == food_pos:
		grow()
		get_parent().increase_score()  # ✅ Add 1 to score when food is eaten
		get_parent().move_food()
	else:
		remove_child(segments[-1])
		segments.pop_back()

func grow():
	var new_part = ColorRect.new()
	new_part.color = Color(0.2, 0.8, 0.3)
	new_part.size = Vector2(segment_size, segment_size)
	new_part.position = segments[-1].position
	add_child(new_part)
	segments.append(new_part)
	
func game_over(reason: String):
	if reason == "self":
		print("💀 Game Over! Snake collided with itself.")
	elif reason == "wall":
		print("💥 Game Over! Snake hit the wall.")
	else:
		print("☠️ Game Over!")
	get_tree().paused = true

func _process(_delta):
	if Input.is_action_just_pressed("move_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT

func _on_move_timer_timeout():
	move()
