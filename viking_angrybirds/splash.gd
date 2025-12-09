extends Node2D

@onready var splash_particles: GPUParticles2D = $splash_particles

func spawn_splash():
	splash_particles.emitting = true
	
