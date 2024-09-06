extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var num_boids_total:int = 32
var boid = preload("res://entities/boid/boid.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_boids_total:
		var instance = boid.instantiate()
		add_child(instance)
		
		# Random position
		instance.global_position.x = randf_range(-30, 30)
		instance.global_position.y = randf_range(-30, 30)
		instance.global_position.z = randf_range(-30, 30)
		
		# Initial velocity/orientation towards origin
		instance.linear_velocity = -global_position.normalized()
		instance.look_at(Vector3.ZERO, Vector3.UP)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_tree().get_nodes_in_group("boids"))
	pass
