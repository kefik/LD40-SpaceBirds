extends Container

const Utils = preload("./Utils.gd")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var ships = get_node("/root/Game/SmallShips")

onready var time = get_node("/root/Game/UI/Time")
onready var score = get_node("/root/Game/UI/Score")
onready var birds = get_node("/root/Game/UI/Birds")
onready var flock = get_node("/root/Game/UI/Flock")
onready var energyDelta = get_node("/root/Game/UI/EnergyDelta")
onready var energy = get_node("/root/Game/UI/Energy")
onready var labels = [ time, score, birds, flock, energyDelta, energy ]

onready var music = get_node("/root/Game/Music")

var playerScore = 0
export var playerEnergyMax = 10
onready var playerEnergy = playerEnergyMax

var gameTime = 0

var targetEnergyDeltaColor = Color(1,1,1,0.3)
var targetEnergyColor = Color(1,1,1,0.3)

var playing = true

var gameOverWindow = preload("res://game_over.tscn")

func _ready():
	set_process(true)
	
func _process(delta):
	if !playing:
		return
	
	var birdsCount = ships.get_child_count()
	birds.text = "#Birds: " + ("%d" % [ birdsCount ])
	
	var flockCount = 0
	for child in ships.get_children():
		if child.inFlock:
			flockCount += 1
	flock.text = "#Flock: " + ("%d" % [flockCount])
	
	playerScore += (0.5 * flockCount + 0.1 * birdsCount) * delta
	score.text = "Score: " + ("%.1f" % [ playerScore ])
	
	gameTime += delta
	time.text = "Time: " + ("%.1f" % [ gameTime ])
	
	# ENERGY DELTA
	var ed = -1
	if birdsCount > 0:
		ed = -1 + 2 * float(flockCount) / float(birdsCount)
	energyDelta.text = "Δ Energy: " + ("%.1f" % [ ed ])
	
	# ENERGY DELTA COLOR
	var a = energyDelta.get_child(0).get_modulate().a
	if ed >= 0:
		targetEnergyDeltaColor = Color(0, 0.5 + ed / 2, 0, a)		
	else:
		targetEnergyDeltaColor = Color(0.5 - ed / 2, 0, 0, a)
		
	var nextColor = Utils.tween_color_perc(energyDelta.get_child(0).get_modulate(), targetEnergyDeltaColor, 1, delta)
	energyDelta.get_child(0).set_modulate(nextColor)
	
	# PLAYER ENERGY
	playerEnergy += ed*delta
	playerEnergy = Utils.f_clamp(playerEnergy, 0, playerEnergyMax)
	energy.text = "Energy: " + ("%.1f" % [ playerEnergy ])
	
	# PLAYER ENERGY COLOR
	a = energy.get_child(0).get_modulate().a
	if playerEnergy >= playerEnergyMax/2:
		targetEnergyColor = Color(0, 0.5 + ((playerEnergy-(playerEnergyMax/2)) / 10), 0, a)		
	else:
		targetEnergyColor = Color(0.5 + ((5-playerEnergy) / (playerEnergyMax/2)), 0, 0, a)
		
	nextColor = Utils.tween_color_perc(energy.get_child(0).get_modulate(), targetEnergyColor, 1, delta)
	energy.get_child(0).set_modulate(nextColor)
	
	#ADAPT BACKGROUND SIZES
	var m = labels[0].backgroundWidth
	for label in labels:
		if m < label.backgroundWidth:
			m = label.backgroundWidth
	for label in labels:
		label.backgroundWidth = m
	
	# GAME OVER?
	if playerEnergy <= 0:
		game_over()
		
func game_over():
	playing = false
	get_node("/root/Game/Player").queue_free()
	
	music.stopMusic()
	
	
	var go = gameOverWindow.instance()
	go.score = playerScore
	go.time = gameTime
	
	go.set_pos(Vector2(get_viewport_rect().size.x / 2 - 150, get_viewport_rect().size.y / 2 - 70))
	
	get_parent().add_child(go)
	