extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Utils = preload("res://scripts/Utils.gd")

var previousMousePos = null
var mousePos = null

var targetRot = 0
var targetScaleY = 1

var origScaleY = 0

onready var music = get_node("/root/Game/Music")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	set_fixed_process(true)
	
	origScaleY = get_scale().y
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	print("Initial mouse pos: ", get_viewport().get_mouse_pos())
	
	print ("Viewport: ", get_viewport_rect().size)
	print ("Viewport/2: ", get_viewport_rect().size / 2)
	
	music = get_node("/root/Game/Music")
	music.playMusic()
	
func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if (ev.is_action_pressed("MLB")):
			print("Mouse Left Button PRESSED",ev.pos)
		if (ev.is_action_released("MLB")): 
			print("Mouse Left Button RELEASED",ev.pos)
		if (ev.is_action_pressed("MRB")):
			print("Mouse Right Button PRESSED",ev.pos)
		if (ev.is_action_released("MRB")): 
			print("Mouse Right Button RELEASED",ev.pos)
	elif (ev.type==InputEvent.MOUSE_MOTION):
		if mousePos == null:
			mousePos = get_viewport_rect().size / 2
		else:
			var delta = ev.pos - (get_viewport_rect().size / 2)
			mousePos += delta
			mousePos = Utils.v2_clamp(mousePos, 0, get_viewport_rect().size.x, 0, get_viewport_rect().size.y)
			#print("Mouse delta: ", delta)
			#print("Mouse pos at: ",mousePos)
	
func _fixed_process(delta):
	if previousMousePos == null:
		previousMousePos = mousePos
	if mousePos != null:		
	
		# ADAPT ROTATION
		if previousMousePos.x == mousePos.x:
			if abs(targetRot) < 0.01:
				targetRot = 0
			else:
				targetRot *= 0.7
		else:
			var diff = -(mousePos.x - previousMousePos.x)
			targetRot += diff * PI/32
			targetRot = Utils.f_clamp(targetRot, -PI/8, PI/8)
		var nextRot = get_rot() + (targetRot - get_rot()) * 2 * delta	
		set_rot(nextRot)
		#print("Target rot: ", targetRot, " Current: ", nextRot)
		
		# ADAPT SCALE
		if previousMousePos.y == mousePos.y:
			if abs(targetScaleY-origScaleY) < 0.01:
				targetScaleY = origScaleY
			else:
				targetScaleY = origScaleY + (targetScaleY-origScaleY) * 0.7
		else:
			var diff = -(mousePos.y - previousMousePos.y)
			targetScaleY += diff * 0.1 * delta
			targetScaleY = Utils.f_clamp(targetScaleY, origScaleY - 0.04, origScaleY + 0.06)
		var nextScaleY = get_scale().y + (targetScaleY - get_scale().y) * 2 * delta	
		set_scale(Vector2(get_scale().x, nextScaleY))
		#print("Target scale Y: ", targetScaleY, " Current: ", nextScaleY)
	
		# ADAPT POSITION
		set_pos(mousePos)
		
		# MOVE STARS
		var viewport = get_viewport_rect().size
		
		var s1 = get_node("/root/Game/Stars1")
		var s2 = get_node("/root/Game/Stars2")
		
		s1.set_pos(Vector2(-(mousePos.x - viewport.x/2) / 24, 0))
		s2.set_pos(Vector2(-(mousePos.x - viewport.x/2) / 18, 0))
		
		previousMousePos = mousePos