extends Node2D

@onready var axe: RigidBody2D = $axe
@onready var start_pos: Node2D = $"start pos"

@onready var throw: Node2D = $Throw
@onready var throw_2: Node2D = $Throw2
@onready var throw_3: Node2D = $Throw3

@onready var timer: Timer = $Timer
@onready var world: Node2D = $"."


@onready var level_spawn: Node2D = $level_spawn

const LEVEL_1 = preload("res://level_1.tscn")
const LEVEL_2 = preload("res://level_2.tscn")
const LEVEL_3 = preload("res://level_3.tscn")

const SHEEP = preload("res://sheep.tscn")

const AXE_scene = preload("res://axe.tscn")

var test_vec = Vector2.RIGHT

@export var Throw_power = 5.0
var is_dragging = false
var from_start = Vector2.ZERO
var direction = Vector2.ZERO
var impulse = null
var throw_length = null

var should_draw_line = false
var line_start = Vector2.ZERO
var line_end = Vector2.ZERO

@onready var gpu_particles_2d: GPUParticles2D = $confetti/GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $confetti/GPUParticles2D2
@onready var gpu_particles_2d_3: GPUParticles2D = $confetti/GPUParticles2D3

@onready var text_edit: TextEdit = $CanvasLayer/TextEdit
@onready var text_edit_2: TextEdit = $CanvasLayer/TextEdit2

var sheep_left = null
var current_level: Node = null
var current_level_index = null

@onready var new_level_timer: Timer = $new_level_timer

func confetti_spawn():
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
	gpu_particles_2d_3.emitting = true


func spawn_level_1():
	spawn_new_axe()
	#sheep_left = 2
	current_level = LEVEL_1.instantiate()
	current_level_index = 1
	world.add_child(current_level)
	current_level.global_position = level_spawn.global_position
	text_edit.text = " LEVEL 1"
	
	for sheep in current_level.get_tree().get_nodes_in_group("sheep"):
		sheep.sheep_explode.connect(self.sheep_explode)
	sheep_left = current_level.get_tree().get_nodes_in_group("sheep").size()

func spawn_level_2():
	if current_level != null and current_level.is_inside_tree():
		current_level.queue_free()
		
	spawn_new_axe()
	#sheep_left = 2 #DETTE SKAPER LVL 3 PROBLEMET >:(
	current_level = LEVEL_2.instantiate()
	current_level_index = 2
	world.add_child(current_level)
	current_level.global_position = level_spawn.global_position
	
	text_edit.text = " LEVEL 2"
	confetti_spawn()
	
	for sheep in current_level.get_tree().get_nodes_in_group("sheep"):
		sheep.sheep_explode.connect(self.sheep_explode)
	sheep_left = current_level.get_tree().get_nodes_in_group("sheep").size()

func spawn_level_3():
	if current_level != null and current_level.is_inside_tree():
		current_level.queue_free()
		
	spawn_new_axe()
	#sheep_left = 3
	current_level = LEVEL_3.instantiate()
	current_level_index = 3
	world.add_child(current_level)
	current_level.global_position = level_spawn.global_position
	text_edit.text = " LEVEL 3"
	confetti_spawn()
	
	for sheep in current_level.get_tree().get_nodes_in_group("sheep"):
		sheep.sheep_explode.connect(self.sheep_explode)
	sheep_left = current_level.get_tree().get_nodes_in_group("sheep").size()

func _ready() -> void:
	axe.gravity_scale = 0.0
	axe.global_position = start_pos.global_position
	throw.global_position = start_pos.global_position
	throw_2.global_position = start_pos.global_position
	throw_3.global_position = start_pos.global_position
	
	spawn_level_1()

#func spawn_new_level():
	#if current_level_index == 1:
		#spawn_level_2()
	#if current_level_index == 2:
		#spawn_level_3()
	#if current_level_index == 3:
		#spawn_level_3()

func sheep_explode():
	sheep_left = sheep_left - 1

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		print("restart")
		get_tree().reload_current_scene()
	if Input.is_action_pressed("e"):
		spawn_new_axe()
	if Input.is_action_pressed("one"):
		spawn_level_1()
	if Input.is_action_pressed("two"):
		spawn_level_2()
	if Input.is_action_pressed("three"):
		spawn_level_3()
	if sheep_left <= 0 and current_level_index == 1:
		await get_tree().create_timer(0.5).timeout
		spawn_level_2()
	elif sheep_left == 0 and current_level_index == 2:
		confetti_spawn()
		await get_tree().create_timer(0.5).timeout
		spawn_level_3()

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		if throw.global_position.distance_to(get_global_mouse_position()) < 100 and timer.is_stopped():
				is_dragging = true
				throw.global_position = get_global_mouse_position()
				throw_3.global_position = start_pos.global_position + from_start * (1.0 / 3.0)
				throw_2.global_position = start_pos.global_position + from_start * (2.0 / 3.0)
				
				from_start = throw.global_position - axe.global_position
				direction = from_start.normalized()
				throw_length = from_start.length()
				
				
	else:
		if is_dragging == true:
			var times_thrown = 0
			is_dragging = false
			axe.gravity_scale = 1.0
			axe.angular_velocity = 10
			
			throw.global_position = start_pos.global_position
			throw_2.global_position = start_pos.global_position
			throw_3.global_position = start_pos.global_position
			
			impulse = -direction * throw_length * Throw_power
			axe.apply_central_impulse(impulse)
			
#e			text_edit_2.text = "Axes thrown: " + str(times_thrown)
			timer.start()
	
func spawn_new_axe():
	if axe:
		axe.queue_free()
		
		axe = AXE_scene.instantiate()
		axe.global_position = start_pos.global_position
		world.add_child(axe)
		timer.stop()
		

func _on_timer_timeout() -> void:
	timer.stop()
	print("TIME OUT")
	spawn_new_axe()
