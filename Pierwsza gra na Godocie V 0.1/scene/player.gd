extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var alive = true

@onready var sprite = $AnimatedSprite2D
@onready var dead_text = $dead_text

func _physics_process(delta):
	if alive:
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("Up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_floor() && direction != 0:
			sprite.play('run')
		elif is_on_floor():
			sprite.play('idle')
		elif !is_on_floor():
			sprite.play("jump")
			
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false
		

		move_and_slide()
	else:
		if Input.is_action_just_pressed("Reset"):
			get_tree().reload_current_scene()
		

func _on_area_2d_body_entered(body):
	alive = false
	sprite.visible = false
	dead_text.visible = true
