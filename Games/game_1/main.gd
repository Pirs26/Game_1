extends Node2D

var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

const INITIAL_BALL_SPEED = 80
var ball_speed = INITIAL_BALL_SPEED
const PAD_SPEED = 160

func _ready() -> void:
	screen_size = get_viewport_rect().size
	pad_size = get_node("Left").get_child(0).shape.size
	set_process(true)

func _process(delta: float) -> void:
	var ball_pos = get_node("Ball").position
	var left_rect = Rect2(get_node("Left").position - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("Right").position - pad_size*0.5, pad_size)
	ball_pos += ball_speed * delta * direction
	
	if (ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0):
		direction.y = -direction.y
		
	if ((right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = -(right_rect.position.y + right_rect.size.y/2 - ball_pos.y)/right_rect.size.y
		direction = direction.normalized()
		ball_speed *= 1.1
		
	if ((left_rect.has_point(ball_pos) and direction.x < 0)):
		direction.x = -direction.x
		direction.y = -(left_rect.position.y + left_rect.size.y/2 - ball_pos.y)/left_rect.size.y
		direction = direction.normalized()
		ball_speed *= 1.1
		
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1.0, 0.0)
	get_node("Ball").position = ball_pos
	
	# Move left pad
	var left_pos = get_node("Left").position

	if (left_pos.y > 0 and Input.is_action_pressed("up_1")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("down_1")):
		left_pos.y += PAD_SPEED * delta

	get_node("Left").position = left_pos

	# Move right pad
	var right_pos = get_node("Right").position

	if (right_pos.y > 0 and Input.is_action_pressed("up_2")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("down_2")):
		right_pos.y += PAD_SPEED * delta

	get_node("Right").position = right_pos
