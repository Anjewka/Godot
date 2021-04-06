extends Node2D

onready var asprite = $AnimatedSprite

func _ready():
	asprite.frame = 0
	asprite.play("Animate")

func _on_AnimatedSprite_animation_finished():
	queue_free()
