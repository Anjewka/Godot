extends KinematicBody2D

enum {move, roll, attack}
var v = Vector2(0, 0)
var state = move
var roll_vec = Vector2.DOWN

export var m_speed = 80
export var roll_speed = 100
export var acceleration = 500
export var f = 500

onready var aplayer = $AnimationPlayer
onready var atree = $AnimationTree
onready var astate = atree.get("parameters/playback")
onready var hitbox = $HitBoxRotate/HitBox

func _ready():
	atree.active = true
	hitbox.knockback_vector = roll_vec

func _process(delta):
	match state:
		move: Move(delta)
		roll: Roll(delta)
		attack: Attack(delta)
	
func Move(delta):
	var n = Vector2.ZERO
	n.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	n.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	n = n.normalized()
	
	if n != Vector2.ZERO:
		roll_vec = n
		hitbox.knockback_vector = roll_vec
		atree.set("parameters/Idle/blend_position", n)
		atree.set("parameters/Run/blend_position", n)
		atree.set("parameters/Attack/blend_position", n)
		atree.set("parameters/Roll/blend_position", n)
		astate.travel("Run")
		v = v.move_toward(n * m_speed, acceleration * delta)
	else :
		astate.travel("Idle")
		v = v.move_toward(Vector2.ZERO, f * delta) 
		
	move()
	
	if Input.is_action_pressed("ui_roll"):
		state = roll
	
	if Input.is_action_pressed("ui_attack"):
		state = attack

func Roll(delta):
	v = roll_vec * roll_speed
	astate.travel("Roll")
	move()
	
func Attack(delta):
	v = Vector2.ZERO
	astate.travel("Attack")
	
func move():
	v = move_and_slide(v)
	
func AttackFinished():
	state = move

func roll_animation_finished():
	state = move
