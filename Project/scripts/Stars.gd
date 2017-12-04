extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var total_stars = 50
export var max_stars_per_frame = 10
export var min_star_speed = 50
export var max_star_speed = 300

export var startTimeDelay = 2.5

onready var star_proto = preload("res://star.tscn")

var stars = []

var pool = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	if startTimeDelay > 0:
		startTimeDelay -= delta
		return
	
	var i = 0
	while i < stars.size():
		var star = stars[i]		
		if star.get_pos().y > Globals.get("display/height"):
			stars.remove(i)
		else:
			i += 1
	
	i = 0
	while (total_stars < 1 || stars.size() < total_stars) && i < max_stars_per_frame:
		add_new_star()
		i += 1
		
func add_new_star():
	var s = null
	
	if pool.size() == 0:
		s = star_proto.instance()
	else:
		s = pool[pool.size()-1]
		pool.pop_back()
		
	var width = int(Globals.get("display/width"))
	s.set_pos(Vector2(-width / 2 + (2 * (randi()%width)), 0))
	s.speed = randi()%(max_star_speed - min_star_speed) + min_star_speed
	s.set_process(true)
	add_child(s)
	if total_stars > 0:
		stars.push_back(s)
	
func pool_star(star):
	pool.push_back(star)
	get_node(".").remove_child(star)
	star.set_process(false)
