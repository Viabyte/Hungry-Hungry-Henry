extends Node2D

const Item := preload("res://Scene/Actor/Item.tscn")

onready var timer := $Timer
onready var entity_layer := $EntityLayer

onready var reward1 := $RewardPlants/uno
onready var reward2 := $RewardPlants/dos
onready var reward3 := $RewardPlants/tres
onready var reward4 := $RewardPlants/cuatro
onready var reward5 := $RewardPlants/cinco
onready var reward6 := $RewardPlants/seis

onready var screen := get_viewport_rect().size

func _ready():
	DataManager.play_music("plant_in_a_hurry")
	DataManager.connect_achievements(self)
	timer.start()

func _on_Timer_timeout():
	new_item(int(DataManager.random(0, DataManager.POWER.size())))

func new_item(id: int):
	var item: Node
	
	if id < 1:
		id = 1
	
	match id:
		DataManager.POWER.DUMMY:
			return
		DataManager.POWER.CLOCK:
			item = spawn_item(id, 1, true, 0.1)
			item.shape = Vector2(16, 16)
			item.texture = load("res://Graphic/Actor/clock.png")
			item.hframes = 12
		DataManager.POWER.TV:
			item = spawn_item(id, 2, true, 0.1)
			item.texture = load("res://Graphic/Actor/tv.png")
			item.shape = Vector2(32, 20)
			item.hframes = 3
		DataManager.POWER.SKATE:
			item = spawn_item(id, 1.2, true, 0.1)
			item.texture = load("res://Graphic/Actor/roller_skate.png")
			item.shape = Vector2(16, 16)
			item.hframes = 4
		DataManager.POWER.VACUUM:
			item = spawn_item(id, 1.8, true, 0.1)
			item.texture = load("res://Graphic/Actor/vacuum.png")
			item.shape = Vector2(32, 20)
			item.hframes = 2
		DataManager.POWER.PRINTER:
			item = spawn_item(id, 1.9, true, 0.1)
			item.texture = load("res://Graphic/Actor/printer.png")
			item.shape = Vector2(32, 20)
			item.hframes = 4
		DataManager.POWER.KILLER:
			item = spawn_item(id, 1.8, true, 0.1)
			item.texture = load("res://Graphic/Actor/plant_killer.png")
			item.shape = Vector2(16, 16)
			item.hframes = 4
	
	if not item:
		print("Failed to spawn item")
		return
	
	entity_layer.add_child(item)
	item.global_position.x = round(DataManager.random(32, screen.x - 32))

func spawn_item(id: int, speed := 1.0, animated := false, animation_speed := 1.0) -> Node:
	var item := Item.instance()
	item.id = id
	item.speed = speed
	item.animated = animated
	item.animation_speed = animation_speed
	return item

func _on_1():
	reward1.visible = true

func _on_2():
	reward2.visible = true

func _on_3():
	reward3.visible = true

func _on_4():
	reward4.visible = true

func _on_5():
	reward5.visible = true

func _on_6():
	reward6.visible = true
