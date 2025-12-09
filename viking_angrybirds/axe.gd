extends RigidBody2D

#from splash scene
const SPLASH = preload("res://splash.tscn")

@onready var splash_particles: GPUParticles2D = $splash_particles
@onready var splash_particles_2: GPUParticles2D = $splash_particles2
@onready var splash_particles_3: GPUParticles2D = $splash_particles3

@onready var icon: Sprite2D = $Icon

var max_destroy = 1
var destroyed = 0

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("breakable") and destroyed < max_destroy:
		body.queue_free()
		destroyed += 1
		print("yes")
	if body.is_in_group("water"):
		self.rotation = 0
		splash_particles.rotation = 0
		splash_particles_2.rotation = 0
		splash_particles_3.rotation = 0
		splash_particles.emitting = true
		splash_particles_2.emitting = true
		splash_particles_3.emitting = true
		self.freeze
		icon.visible = false
		self.linear_velocity = Vector2.ZERO
		self.sleeping = true
		

#func spawn_splash() -> void:
	#var splash_instance = SPLASH.instantiate()
	#get_tree().current_scene.add_child(splash_instance)
#
	## If the root isn't a GPUParticles2D, find it
	#var particles: GPUParticles2D = splash_instance if splash_instance is GPUParticles2D else splash_instance.get_node_or_null("GPUParticles2D")
	#if particles:
		#particles.emitting = true
