extends CanvasLayer

const UI := preload("res://Scene/UI.tscn")

enum POWER{
	DUMMY,
	CLOCK,
	TV,
	SKATE,
	VACUUM,
	PRINTER,
	KILLER
}

var fall_mod := 0.5

var clock_count := 0
var tv_count := 0
var skate_count := 0
var vacuum_count := 0
var printer_count := 0
var killer_count := 0

var clock_mod := 0
var tv_mod := 0
var skate_mod := 0
var vacuum_mod := 0
var printer_mod := 0
var killer_mod := 0

var clock_total := 0
var tv_total := 0
var skate_total := 0
var vacuum_total := 0
var printer_total := 0
var killer_total := 0

signal achieve1
signal achieve2
signal achieve3
signal achieve4
signal achieve5
signal achieve6

signal make_clone
signal died

onready var ui: Control
onready var music := AudioStreamPlayer.new()
onready var sound := AudioStreamPlayer.new()

var score := 0
var rounds := 1

var player_position := Vector2.ZERO
var time := 60.0

func _ready():
	add_child(music)
	add_child(sound)
	
	music.volume_db = -4

func remove_ui():
	if has_node("UI"):
		ui.queue_free()
		time = 60

func new_ui():
	if has_node("UI"):
		return
	ui = UI.instance()
	add_child(ui)

func play_music(path: String):
	music.stream = load("res://Audio/Music/" + path + ".wav")
	music.play()

func play_sound(path: String):
	sound.stream = load("res://Audio/Sound/" + path + ".wav")
	sound.play()

func random(from := 0.0, to := 1.0) -> float:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	return rng.randf_range(from, to)

func add_combo(id: int):
	ui.add_combo(id)
	
	if score >= 100:
		emit_signal("achieve3")
	if clock_total >= 20:
		emit_signal("achieve2")
	if killer_total >= 5:
		emit_signal("achieve4")
	
	var mod_count := 0
	var mods := [clock_mod, tv_mod, skate_mod, vacuum_mod, printer_mod]
	for i in mods:
		if i > 0:
			mod_count += 1
	if mod_count >= 3:
		emit_signal("achieve5")

func connect_achievements(obj: Node):
	var _err = connect("achieve1", obj, "_on_1")
	_err = connect("achieve2", obj, "_on_2")
	_err = connect("achieve3", obj, "_on_3")
	_err = connect("achieve4", obj, "_on_4")
	_err = connect("achieve5", obj, "_on_5")
	_err = connect("achieve6", obj, "_on_6")

func tictock():
	if clock_mod:
		time -= 0.5
	else:
		time -= 1
	if time <= 0:
		rounds += 1
		if rounds >= 4:
			remove_ui()
			return
		fall_mod += 0.5
		time = 60
		var mod_count := 0
		var mods := [clock_mod, tv_mod, skate_mod, vacuum_mod, printer_mod]
		for i in mods:
			if i > 0:
				mod_count += 1
		if mod_count == 0:
			emit_signal("achieve6")
		if rounds >= 1:
			emit_signal("achieve1")

func add_count(i: String):
	match i:
		"CLOCK":
			clock_count += 1
			
			if clock_count >= 3:
				clock_mod += 1
				clock_count = 0
		"TV":
			tv_count += 1
			
			if tv_count >= 5:
				tv_mod += 1
				tv_count = 0
		"SKATE":
			skate_count += 1
			
			if skate_count >= 3:
				skate_mod += 1
				skate_count = 0
		"VACUUM":
			vacuum_count += 1
			
			if vacuum_count >= 8:
				vacuum_mod += 1
				vacuum_count = 0
		"PRINTER":
			printer_count += 1
			
			if printer_count >= 5:
				printer_mod += 1
				printer_count = 0
				emit_signal("make_clone")
		"KILLER":
			killer_count += 1
			
			var mod_count := 0
			var mods := [clock_mod, tv_mod, skate_mod, vacuum_mod, printer_mod]
			for i in mods:
				if i > 0:
					mod_count += 1
			if mod_count == 0:
				emit_signal("died")
			
			clock_mod -= 1
			tv_mod -= 1
			skate_mod -= 1
			vacuum_mod -= 1
			printer_mod -= 1
			
# warning-ignore:narrowing_conversion
			clock_mod = clamp(clock_mod, 0, 3)
# warning-ignore:narrowing_conversion
			tv_mod = clamp(tv_mod, 0, 3)
# warning-ignore:narrowing_conversion
			skate_mod = clamp(skate_mod, 0, 3)
# warning-ignore:narrowing_conversion
			vacuum_mod = clamp(vacuum_mod, 0, 3)
# warning-ignore:narrowing_conversion
			printer_mod = clamp(printer_mod, 0, 3)
