extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_facing_right = true
var is_attack = false

var health = 100

@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x > 0:
		is_facing_right = true
	elif velocity.x < 0:
		is_facing_right = false
	if Input.is_action_just_pressed("A") and is_attack == false:
		attack()

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	attack_area.position.x = 0
	pass # Replace with function body.

func attack():
	if is_attack == false and is_facing_right == true:
		is_attack = true
		attack_area.position.x = 75
		attack_timer.start(0.5)
	if is_attack == false and is_facing_right == false:
		is_attack = true
		attack_area.position.x = -75
		attack_timer.start(0.5)
	is_attack = false
	
func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func _on_attack_area_body_entered(body: CharacterBody2D) -> void:
	if body != self and has_method("take_damage"):
		body.take_damage(50)
		pass # Replace with function body.
