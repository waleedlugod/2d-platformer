extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300
@export var max_jumps = 2 # Maximum number of jumps
@onready var sprite_2d = $Sprite2D

var jump_count = 0 # Counter to track jumps
var last_direction = 1 # 1 for right, -1 for left

func _physics_process(delta):
	# Apply gravity when not on the floor
	if !is_on_floor():
		velocity.y += gravity
		sprite_2d.animation = "jumping"
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		# Reset jump count when on the floor
		jump_count = 0
		# Set idle or running animation based on movement
		if velocity.x > 1 or velocity.x < -1:
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"
			# Flip idle animation based on the last direction
			sprite_2d.flip_h = last_direction == 1

	# Jump logic
	if Input.is_action_just_pressed("up") and jump_count < max_jumps:
		velocity.y = -jump_force
		jump_count += 1

	# Horizontal movement
	var horizontal_direction = Input.get_axis("left", "right")
	if horizontal_direction != 0:
		velocity.x = horizontal_direction * speed
		last_direction = horizontal_direction # Store the last direction
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	# Ensure player direction flip during movement or idle
	sprite_2d.flip_h = last_direction == 1

	move_and_slide()
