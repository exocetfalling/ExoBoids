class_name Boid 

extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flock_mean_velocity: Vector3 = Vector3.ZERO
var flock_mean_position: Vector3 = Vector3.ZERO

var flock_num_birds: int = 1

var boid_visual_range: float = 20.0
var boid_separation_vector: Vector3 = Vector3.ZERO
var boid_cohesion_vector: Vector3 = Vector3.ZERO
var boid_alignment_vector: Vector3 = Vector3.ZERO
var boid_target_vector: Vector3 = Vector3.ZERO
var boid_random_vector: Vector3 = Vector3.ZERO
var boid_station_vector: Vector3 = Vector3.ZERO

var input_vector: Vector2 = Vector2.ZERO

var boid_randomness_period: float = 5.0
var boid_speed_scalar: float = 2.0

var elapsed_time: float = 0.0

# Exports
export var COEFF_SEPARATION: float = -0.015
export var COEFF_COHESION: float = 1.2
export var COEFF_ALIGNMENT: float = 1.0
export var COEFF_STATION: float = -0.008
export var COEFF_INPUT: float = 2
export var COEFF_RANDOM: float = 0.75


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	elapsed_time += delta
	
	boid_separation_vector = Vector3.ZERO
	
	for body in $SensedArea.get_overlapping_bodies():
		flock_mean_velocity += body.linear_velocity
		flock_mean_position += body.global_translation
		
		boid_separation_vector += \
			COEFF_SEPARATION * \
			(body.global_translation - global_translation) * \
			(boid_visual_range - (body.global_translation - global_translation).length())
	
	flock_num_birds = len($SensedArea.get_overlapping_bodies()) + 1
	flock_mean_velocity = flock_mean_velocity / flock_num_birds
	flock_mean_position = flock_mean_position / flock_num_birds
	
	boid_cohesion_vector = COEFF_COHESION * (flock_mean_position - global_translation)
	
	boid_alignment_vector = COEFF_ALIGNMENT * flock_mean_velocity
	
	# Get input
	input_vector = COEFF_INPUT * boid_speed_scalar * Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Set target vector with input
	boid_target_vector.x = input_vector.x
	boid_target_vector.z = input_vector.y
	
	# Make boids stay close to origin
	boid_station_vector = COEFF_STATION * boid_speed_scalar * global_translation
	
	if elapsed_time > boid_randomness_period:
		# Reset time 
		elapsed_time = 0
		
		# Set new period
		boid_randomness_period = rand_range(2, 5)
		
		# Set new speed
		boid_speed_scalar = rand_range(2, 5)
		
		# Set random vector
		boid_random_vector.x = boid_speed_scalar * rand_range(-1, 1)
		boid_random_vector.y = boid_speed_scalar * rand_range(-1, 1)
		boid_random_vector.z = boid_speed_scalar * rand_range(-1, 1)
		
		boid_random_vector = COEFF_RANDOM * boid_random_vector
	
	# Debug
#	$CSGCylinder.scale = flock_num_birds / 4 * Vector3.ONE


func _integrate_forces(delta):
	linear_velocity = lerp(\
		linear_velocity, \
		boid_separation_vector + \
		boid_cohesion_vector + \
		boid_alignment_vector + \
		boid_target_vector + \
		boid_random_vector + \
		boid_station_vector, \
		0.02)
	look_at(global_translation + linear_velocity, Vector3.UP)

