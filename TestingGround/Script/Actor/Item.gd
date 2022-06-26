extends Area2D

onready var sprite := $Sprite
onready var collision := $CollisionShape2D
onready var timer := $Timer

var texture: Texture
var hframes := 0
var shape := Vector2.ZERO

var id := 0
var speed := 0.0
var animated := false
var animation_speed := 0.5

var state := 0

func _ready():
	sprite.texture = texture
	sprite.hframes = hframes
	collision.shape.extents = shape
	if animated:
		timer.wait_time = animation_speed
		timer.start()

func _process(_delta):
	match state:
		0:
			global_position.y += (speed + DataManager.fall_mod)
			if global_position.y >= 216:
				queue_free()
		1:
			global_position += global_position.direction_to(DataManager.player_position) * (speed * 1.5)
			scale -= Vector2(0.1, 0.1)
			if scale.x <= 0.1:
				queue_free()

func _on_Timer_timeout():
	if (sprite.frame + 1) >= sprite.hframes:
		sprite.frame = 0
	else:
		sprite.frame += 1

func hit():
	set_deferred("monitorable", false)
	
	DataManager.score += 1
	DataManager.add_combo(id)
	DataManager.play_sound("nom")
	state = 1
