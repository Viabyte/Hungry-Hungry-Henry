extends Control

onready var label := $TopBar/Label
onready var time := $TopBar/TimeLabel
onready var rounds := $TopBar/RoundLabel

var combo_count := 0
var combo := []

var upgrading := false

func _process(_delta):
	label.text = "Score: " + str(DataManager.score)
	rounds.text = "Round: " + str(DataManager.rounds)
	time.text = str(round(DataManager.time))

func add_combo(id: int):
	combo_count += 1
	combo_count = wrapi(combo_count, 0, 4)
	combo.append(id)
	if combo.size() >= 3:
		DataManager.score += 3
		
		var total := []
		
		for i in combo:
			if total:
				if total.has(DataManager.POWER.keys()[i]):
					pass
				else:
					total.append(DataManager.POWER.keys()[i])
			else:
				total.append(DataManager.POWER.keys()[i])
		
		for i in total:
			DataManager.add_count(i)
		
		combo = []

func _on_Timer_timeout():
	DataManager.tictock()
