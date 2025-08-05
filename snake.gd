extends Node2D

var direction = Vector2.RIGHT
var segment_size = 32
var segments = []
var game_area = Vector2(640, 480) # Change this if your screen is different

func _ready():
	spawn_snake()
	set_process(true) # ← add this

func spawn_snake():
	var head = ColorRect.new()
	head.color = Color(0.2, 0.8, 0.3)
	head.size = Vector2(segment_size, segment_size)
	head.position = Vector2(160, 160)
	add_child(head)
	segments.append(head)

func move():
	var new_head_pos = segments[0].position + direction * segment_size

	var new_head = ColorRect.new()
	new_head.color = Color(0.2, 0.8, 0.3)
	new_head.size = Vector2(segment_size, segment_size)
	new_head.position = new_head_pos
	add_child(new_head)
	segments.insert(0, new_head)

	# Food collision
	if segments[0].position == get_parent().get_node("Food").position:
		grow()
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

func _process(_delta):
	print("Processing...")  # debug line
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
