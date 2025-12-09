extends RigidBody2D

@onready var timer: Timer = $Timer
@onready var explotion: Sprite2D = $explotion
@onready var sheep_sprite: Sprite2D = $Sheep
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sheep: RigidBody2D = $"."

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func sheep_ground():
	audio_stream_player_2d.play()
	sheep.freeze = true
	sheep_sprite.visible = false
	collision_shape_2d.disabled = true
	explotion.visible = true
	timer.start()

func sheep_water():
	audio_stream_player_2d.play()
	sheep.freeze = true
	collision_shape_2d.disabled
	sheep_sprite.visible = false
	collision_shape_2d.disabled = true
	explotion.visible = true
	timer.start()

signal sheep_explode

func die():
	emit_signal("sheep_explode")
	self.queue_free()
	
var hit = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("floor") and hit == false:
		hit = true
		print("sheep hit, sheep hit")
		sheep_ground()
	elif body.is_in_group("water") and hit == false:
		hit = true
		sheep_water()



func _on_timer_timeout() -> void:
	die()
