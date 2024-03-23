extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var num_boids_total:int = 32
var boid = preload("res://entities/boid/boid.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_boids_total:
		var instance = boid.instance()
		add_child(instance)
		
		# Random position
		instance.global_translation.x = rand_range(-30, 30)
		instance.global_translation.y = rand_range(-30, 30)
		instance.global_translation.z = rand_range(-30, 30)
		
		# Initial velocity/orientation towards origin
		instance.linear_velocity = -global_translation.normalized()
		instance.look_at(Vector3.ZERO, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_tree().get_nodes_in_group("boids"))
	pass
