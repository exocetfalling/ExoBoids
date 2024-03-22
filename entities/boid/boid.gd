class_name Boid 

extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flock_mean_velocity: Vector3 = Vector3.ZERO
var flock_mean_position: Vector3 = Vector3.ZERO

var flock_num_birds: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	# Do something...
	for body in $SensedArea.get_overlapping_bodies():
		flock_mean_velocity += body.linear_velocity
		flock_mean_position += body.global_translation
	
	flock_num_birds = len($SensedArea.get_overlapping_bodies()) + 1
	flock_mean_velocity = flock_mean_velocity / flock_num_birds
	flock_mean_position = flock_mean_position / flock_num_birds
	
	linear_velocity = lerp(linear_velocity, flock_mean_velocity, 0.01)
	look_at(global_translation + linear_velocity, Vector3.UP)
