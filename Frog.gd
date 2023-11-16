extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var player
var SPEED = 50
var JUMP_VELOCITY = -400

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	#Gravity for frog
	velocity.y += delta * gravity
	
	

	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
#			if is_on_floor():
#				velocity.y = JUMP_VELOCITY
		player = get_node("../../Player/Player")
		
		
		
		
		
		
		var direction = (player.global_position - self.global_position).normalized()

		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	elif is_on_floor() && chase != true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_collision_stomp_body_entered(body):
	if body.name == "Player":
		death()
func _on_collision_damage_body_entered(body):
	if body.name == "Player":
		body.health -= 3
		death()
		
func death():
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
