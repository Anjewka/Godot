extends Node2D

func createGrassEffect():
	var GrassE = load("res://Effects/GrassEffect.tscn")
	var grassE = GrassE.instance()
	var main = get_tree().current_scene
	main.add_child(grassE)
	grassE.global_position = global_position
		
func _on_HurtBox_area_entered(area):
	createGrassEffect()
	queue_free()
