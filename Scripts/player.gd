extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 700
@export var is_underwater = false
@export var max_underwater_velocity = 100
@export var max_jumps = 2 # Maximum number of jumps
@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D

var jump_count = 0 # Counter to track jumps
var last_direction = 1 # 1 for right, -1 for left

func _physics_process(_delta):
	# Underwater logic
	is_underwater = false
	gravity = 30
	jump_force = 700
	speed = 300
	for body in area_2d.get_overlapping_bodies():
		if body.name == "Water":
			is_underwater = true
			gravity = 10
			jump_force = 300
			speed = 100

	# Apply gravity when not on the floor
	if !is_on_floor():
		velocity.y += gravity
		if is_underwater and velocity.y > max_underwater_velocity:
			velocity.y = max_underwater_velocity
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
	if Input.is_action_just_pressed("up") and (jump_count < max_jumps or is_underwater):
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


func _input(event : InputEvent):
	if(event.is_action_pressed("ui_down")):
		position.y += 1
