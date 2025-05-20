extends CharacterBody2D

@onready var player_area2D = $Player_area2D

@export var walk_speed = 200
@export var sprint_speed = 300
var speed

@export var air_speed = 100
@export var air_time = 0.5

var direction: Vector2
var in_air = false
var in_air_timer = 0.0
var on_ground = true

func _physics_process(delta: float) -> void:
	if !in_air:
		in_air_timer = air_time
		if Input.is_action_just_pressed("Jump"):
			in_air = true
			on_ground = false
			disable_area_collision()
	else:
		in_air_timer -= delta
		if in_air_timer <= 0:
			in_air = false
			enable_area_collision()
			await get_tree().create_timer(0.1).timeout
			if !on_ground:
				print("Game over")
				#queue_free()

	
	direction = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		direction.y -= 1
	elif Input.is_action_pressed("Down"):
		direction.y += 1
	if Input.is_action_pressed("Left"):
		direction.x -= 1
	elif Input.is_action_pressed("Right"):
		direction.x += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		if Input.is_action_pressed("Sprint"):
			speed = sprint_speed
		else:
			speed = walk_speed
		if !in_air:
			velocity.x = move_toward(velocity.x, direction.x * speed, 40)
			velocity.y = move_toward(velocity.y, direction.y * speed, 40)
		else:
			velocity.x = move_toward(velocity.x, direction.x * speed, 20)
			velocity.y = move_toward(velocity.y, direction.y * speed, 20)
	else:
		if !in_air:
			velocity.x = move_toward(velocity.x, 0, 40)
			velocity.y = move_toward(velocity.y, 0, 40)
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
			velocity.y = move_toward(velocity.y, 0, 20)
			
	

	
	move_and_slide()

func disable_area_collision():
	player_area2D.collision_layer = 0
	player_area2D.collision_mask = 0

func enable_area_collision():
	player_area2D.collision_layer = 1
	player_area2D.collision_mask = 1

func _on_player_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Furniture"):
		print("Landed on furniture")
		on_ground = true
