extends Area2D

const normal_head_texture := preload("res://Graphic/Actor/plant_head_normal.png")
const clock_head_texture := preload("res://Graphic/Actor/plant_head_clock.png")

enum{
	NORMAL,
	WIDE
}
var mode := NORMAL

onready var pot := $Pot
onready var pot_player := $PotPlayer
onready var head := $Head
onready var head_player := $HeadPlayer
onready var timer := $Timer
onready var collision := $CollisionShape2D
onready var vacuum_collision := $VacuumCollision
onready var particle := $Particles

onready var screen_size := get_viewport().get_visible_rect().size

var movement := 0.0
var speed := 3.5

var is_clone := false
var is_clock := false
var on_wheel := false
var action := false
var eating := false
var idling := false

func _ready():
	vacuum_collision.set_deferred("disabled", true)
	global_position.y = 144
	if is_clone:
		name = "CLONE"

func _process(_delta):
	if DataManager.clock_mod:
		head.texture = clock_head_texture
	else:
		head.texture = normal_head_texture
	var input := round(Input.get_axis("ui_left", "ui_right"))
	action = Input.is_action_pressed("ui_accept")
	
	if DataManager.tv_mod:
		mode = WIDE
	else:
		mode = NORMAL
	
	if DataManager.skate_mod:
		on_wheel = true
	else:
		on_wheel = false
	
	match mode:
		NORMAL:
			collision.shape.extents.x = 8
			collision.position.y = 0
			if action:
				if not eating:
					idling = false
					head_player.play("OpenTransition")
			else:
				if eating:
					head_player.play("CloseTransition")
			
			if input:
				idling = false
				timer.start()
				if on_wheel:
					pot_player.play("SkateRun")
				else:
					pot_player.play("Run")
				movement = lerp(movement, input * speed, 0.1)
				pot.scale.x = input
			else:
				if idling and not eating:
					if on_wheel:
						pot_player.play("SkateIdle")
					else:
						pot_player.play("Idle")
					head_player.play("Idle")
				else:
					if on_wheel:
						pot_player.play("SkateIdle")
					else:
						pot_player.play("IdleShort")
				movement = lerp(movement, 0, 0.2)
		WIDE:
			gimmick_run(input, "Run", "IdleShort", "TV_Open", true)
	
	if is_clone:
		if not DataManager.printer_mod:
			queue_free()
		if global_position.distance_to(DataManager.player_position) < 64:
			movement = 0
			if DataManager.player_position.x < screen_size.x:
				movement = lerp(movement, -1, 0.2)
			else:
				movement = lerp(movement, 1, 0.2)
	
	if DataManager.skate_mod:
		global_position.x += movement * 1.5
	else:
		global_position.x += movement
	
	global_position = global_position.round()
	
	if global_position.x < 32 or global_position.x > 288:
		movement = 0
	global_position.x = clamp(global_position.x, 32, 288)
	
	if not is_clone:
		DataManager.player_position = global_position

func gimmick_run(input: float, run_anim: String, idle_anim: String, open_anim: String, is_wide := false):
	if is_wide:
		collision.shape.extents.x = 16
		collision.position.y = -16
	else:
		collision.shape.extents.x = 8
		collision.position.y = 0
	if input:
		idling = false
		timer.start()
		if on_wheel:
			pot_player.play("SkateRun")
		else:
			pot_player.play(run_anim)
		movement = lerp(movement, input * speed, 0.1)
		pot.scale.x = input
	else:
		if on_wheel:
			pot_player.play("SkateIdle")
		else:
			pot_player.play(idle_anim)
		movement = lerp(movement, 0, 0.2)
	if not eating:
		head_player.play(open_anim)

func _on_HeadPlayer_animation_finished(anim_name):
	match anim_name:
		"CloseTransition":
			eating = false
			head_player.play("Closed")
		"OpenTransition":
			eating = true
			head_player.play("Open")
		"TV_Eat":
			eating = false

func _on_Plant_area_entered(area):
	if area.has_method("hit"):
		match mode:
			NORMAL:
				if eating:
					head_player.play("CloseTransition")
					area.hit()
			WIDE:
				eating = true
				head_player.play("TV_Eat")
				area.hit()

func _on_Timer_timeout():
	if DataManager.vacuum_mod:
		vacuum_collision.disabled = false
		particle.visible = true
	else:
		particle.visible = false
	if not DataManager.clock_mod:
		idling = true
