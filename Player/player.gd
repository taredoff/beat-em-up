extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_facing_right = true
var is_attacking = false

@onready var attack_area: Area2D = $AttackArea
@onready var attack_cooldown: Timer = $AttackCooldown
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
	if velocity.x < 0:
		is_facing_right = false
	
	if Input.is_action_just_pressed("A"):
		_attack()
	
	move_and_slide()

func _attack():
	if is_attacking == false and is_facing_right == true:
		is_attacking = true
		attack_timer.start()
		attack_area.visible = true
		attack_area.position.x = 15
	if is_attacking == false and is_facing_right == false:
		is_attacking = true
		attack_timer.start()
		attack_area.visible = true
		attack_area.position.x = -15
	pass

func _on_attack_timer_timeout() -> void:
	attack_area.visible = false
	attack_area.position.x = 0
	attack_cooldown.start()
	pass # Replace with function body.

func _on_attack_cooldown_timeout() -> void:
	is_attacking = false
	pass # Replace with function body.
