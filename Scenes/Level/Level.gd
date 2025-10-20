extends Node2D

# The snake moves along the edges of the matrix and not inside the cell of the matrix...
# technically it still works
#
# But I need to fix
#
#
# It only creates more problems if you try to fix it


#region Variables
var game_started: bool = false

@export var snake_scene : PackedScene
@export var fruit_scene : PackedScene

@onready var hud: CanvasLayer = $Hud
@onready var move_timer: Timer = $MoveTimer
@onready var game_over: CanvasLayer = $GameOver

# Grid variables
var vertical_cell: int = 24
var horizontal_cell: int = 32
var cell_size: int = 20

# Snake variables
# 3 array
var old_body_snake: Array = []
var body_snake: Array = []
var snake: Array = []

# Move variables
var start_pos: Vector2 = Vector2(15, 11)
var up: Vector2 = Vector2(0, -1)
var down: Vector2 = Vector2(0, 1)
var left: Vector2 = Vector2(-1, 0)
var right: Vector2 = Vector2(1, 0)
var move_direction: Vector2
var can_move: bool

# Fruit variables
var fruit: Node2D
var fruit_pos: Vector2

#endregion


func _ready() -> void:
	new_game()
	#_draw()


# Draw the game grid
# Debug only use
#func _draw() -> void:
#	for y in range(vertical_cell):
#		for x in range(horizontal_cell):
#			var pos = Vector2(x, y) * cell_size + Vector2(0, cell_size)
#			draw_rect(Rect2(pos, Vector2(cell_size, cell_size)), Color(0.5, 0.5, 0.5), false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit") == true:
		GameManager.set_mode("menu")


func new_game() -> void:
	get_tree().paused = false
	get_tree().call_group("segments_snake", "queue_free")
	game_over.hide()
	ScoreManager.reset_points()
	hud.score_label_modifier(ScoreManager.score)
	move_direction = up
	can_move = true
	generate_snake()
	add_fruit()


func _process(_delta: float) -> void:
	handle_input()


#func grid_to_pixel_centered(pos: Vector2) -> Vector2:
#	return (pos * cell_size) + Vector2(cell_size / 2, cell_size / 2)


#region Snake Logic
func generate_snake() -> void:
	old_body_snake.clear()
	body_snake.clear()
	snake.clear()
	
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))


func add_segment(pos: Vector2) -> void:
	body_snake.append(pos)
	var snake_segment = snake_scene.instantiate()
	snake_segment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(snake_segment)
	snake.append(snake_segment)


func handle_input() -> void:
	# Input keypresses
	if can_move == true:
		if Input.is_action_just_pressed("Down") && move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Up") && move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Left") && move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Right") && move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()


func start_game() -> void:
	game_started = true
	move_timer.start()


func _on_move_timer_timeout() -> void:
	can_move = true
	
	old_body_snake = body_snake.duplicate()
	body_snake[0] += move_direction
	
	for i in range(len(body_snake)):
		if i > 0:
			body_snake[i] = old_body_snake[i - 1]
		#snake[i].position = grid_to_pixel_centered(body_snake[i])
		snake[i].position = (body_snake[i] * cell_size) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()


func check_out_of_bounds() -> void:
	if body_snake[0].x < 1 or body_snake[0].x > horizontal_cell - 1 \
	or body_snake[0].y < 2 or body_snake[0].y > vertical_cell - 2:
		#print("You are off the map!")  # debug
		end_game()


func check_self_eaten() -> void:
	for i in range(1, len(body_snake)):
		if body_snake[0] == body_snake[i]:
			end_game()


func end_game() -> void:
	game_over.show()
	move_timer.stop()
	game_started = false
	get_tree().paused = true

#endregion


#region Food Logic
func add_fruit() -> void:
	if fruit != null:
		fruit.queue_free()

	var pos := get_random_free_cell()
	fruit = fruit_scene.instantiate()
	#fruit.position = grid_to_pixel_centered(pos)
	fruit.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(fruit)
	fruit_pos = pos


func get_random_free_cell() -> Vector2:
	var free_positions: Array = []
	for y in range(2, vertical_cell - 2):  # avoid the forbidden lines
		for x in range(1, horizontal_cell - 1):   # all the columns are valid
			var cell := Vector2(x, y)
			if cell not in body_snake:
				free_positions.append(cell)

	if free_positions.is_empty():
		return start_pos  # fallback

	return free_positions[randi() % free_positions.size()]


func check_food_eaten() -> void:
	if body_snake[0] == fruit_pos:
		ScoreManager.add_points(1)
		hud.score_label_modifier(ScoreManager.score)
		add_segment(old_body_snake[-1])
		add_fruit()

#endregion


func _on_game_over_restart() -> void:
	new_game()
