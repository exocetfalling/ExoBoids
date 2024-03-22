class_name Boid 

extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flock_mean_velocity: Vector3 = Vector3.ZERO
var flock_mean_position: Vector3 = Vector3.ZERO

var flock_num_birds: int = 1

var boid_visual_range: float = 20.0
var boid_avoidance_vector: Vector3 = Vector3.ZERO
var boid_cohesion_vector: Vector3 = Vector3.ZERO
var boid_target_vector: Vector3 = Vector3.ZERO
var boid_random_vector: Vector3 = Vector3.ZERO

var input_vector: Vector2 = Vector2.ZERO

var boid_randomness_period: float = 5.0
var elapsed_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	elapsed_time += delta
	
	boid_avoidance_vector = Vector3.ZERO
	
	for body in $SensedArea.get_overlapping_bodies():
		flock_mean_velocity += body.linear_velocity
		flock_mean_position += body.global_translation
		
		boid_avoidance_vector += \
			-0.01 * \
			(body.global_translation - global_translation) * \
			(boid_visual_range - (body.global_translation - global_translation).length())
	
	flock_num_birds = len($SensedArea.get_overlapping_bodies()) + 1
	flock_mean_velocity = flock_mean_velocity / flock_num_birds
	flock_mean_position = flock_mean_position / flock_num_birds
	
	boid_cohesion_vector = 1 * (flock_mean_position - global_translation)
	
	# Get input
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Set target vector with input
	boid_target_vector.x = input_vector.x
	boid_target_vector.z = input_vector.y
	
	if elapsed_time > boid_randomness_period:
		# Reset time 
		elapsed_time = 0
		
		# Set new period
		boid_randomness_period = rand_range(2, 5)
		
		# Set random vector
		boid_random_vector.x = rand_range(-1, 1)
		boid_random_vector.y = 0
		boid_random_vector.z = rand_range(-1, 1)
	


func _integrate_forces(delta):
	linear_velocity = lerp(\
		linear_velocity, \
		flock_mean_velocity + \
		boid_avoidance_vector + \
		boid_cohesion_vector + \
		boid_target_vector + \
		boid_random_vector, \
		0.02)
	look_at(global_translation + linear_velocity, Vector3.UP)

