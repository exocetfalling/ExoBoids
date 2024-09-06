extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var num_boids_total:int = 32
var boid = preload("res://entities/boid/boid.tscn")
var elapsed_time_total: float = 0

var boid_batch_num: int = 1
@export var boid_batch_size: int = 32

var boid_batch_index_min: int = 0
var boid_batch_index_max: int = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_boids_total:
		var instance = boid.instantiate()
		instance.boid_index = i + 1
		add_child(instance)
		
		# Random position
		instance.global_position.x = randf_range(-30, 30)
		instance.global_position.y = randf_range(-30, 30)
		instance.global_position.z = randf_range(-30, 30)
		
		# Initial velocity/orientation towards origin
		instance.velocity = -global_position.normalized()
		instance.look_at(Vector3.ZERO, Vector3.UP)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	elapsed_time_total += delta
	
	if boid_batch_index_min > num_boids_total:
		boid_batch_num = 1
		boid_batch_index_min = 1
		boid_batch_index_max = boid_batch_index_min + boid_batch_size
	
	for child in get_children():
		if child is Boid:
			if child.boid_index >= boid_batch_index_min and child.boid_index < boid_batch_index_max:
				child.flock_logic(delta)
	
	boid_batch_num += 1
	boid_batch_index_min += boid_batch_size
	boid_batch_index_max += boid_batch_size
	
	pass
