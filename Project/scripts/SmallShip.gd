extends Sprite

const Utils = preload("res://scripts/Utils.gd")

export var reactionDistance = 100

export var cruiseSpeed = 50

export var accelPerc = 2

export var rotationSpeedPerc = 2 

export var followSpeed = 50

export var myColor = -1
export var targetColor = Color(0,0,0)

export var flocking = true
export var flockDistance = 100
export var flockHeadingWeight = 0.8
export var flockCenterWeight = 1.0
export var flockAvoidanceWeight = 0.4

var currentSpeed = -1

var inFlock = false

var others = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if myColor < 0:
		myColor = randf()/3+0.6

	targetColor = Color(1, myColor, myColor)
	set_modulate(Color(1, myColor, myColor))
	#set_rot(-PI/2)
	set_fixed_process(true)
	currentSpeed = cruiseSpeed
	
func _fixed_process(delta):
	var game = get_node("/root/Game")
	var player = null
	if game.has_node("Player"):
		player = get_node("/root/Game/Player")
	if player != null && (player.get_pos() - get_pos()).length() < reactionDistance:
		inFlock = true
		move_to_player(delta, player)
	else:
		inFlock = false
		cruise(delta)
		
	check_disappear()
		
func cruise(delta):
	targetColor = Color(1, myColor, myColor)	
	if flocking:
		flock(delta)		
	else:
		move_in_dir(delta, cruiseSpeed)
	
func flock(delta):
	var current = []
	
	for ship in others:
		if (ship.get_pos() - get_pos()).length() < flockDistance:
			current.push_back(ship)
	
	# FIND OTHER SHIPS
	if current.size() < 10:
		for ship in get_parent().get_children():
			if ship == get_node("."):
				continue
			if (ship.get_pos() - get_pos()).length() < flockDistance:
				var add = true
				for c in current:
					if c == ship:
						add = false
						break
				if add:
					current.push_back(ship)
					if current.size() >= 15:
						break
	
	others = current
	
	if others.size() == 0:
		move_in_dir(delta, cruiseSpeed)
		return
	
	# ORTHOCENTER
	var center = Vector2(0,0)
	var headingRot = 0
	var avoidingDir = Vector2(0,0)
	
	for ship in others:
		center += ship.get_pos()
		headingRot += Utils.vec_to_rot(Utils.rot_to_vec(ship.get_rot()))
		var avoid = (get_pos() - ship.get_pos()).normalized()
		avoidingDir = (avoidingDir + avoid).normalized()
		
	center /= others.size()
	headingRot /= others.size()
	
	# WANT TO BE IN THE CENTER
	var centerDir = (center - get_pos()).normalized()
	
	# WANT TO HAVE THE COMMON HEADING
	var headingDir = Utils.rot_to_vec(headingRot).normalized()
	
	# WANT TO AVOID OTHERS
	
	# TARGET MOVE
	var targetDir = (flockCenterWeight * centerDir + flockHeadingWeight * headingDir + flockAvoidanceWeight * avoidingDir).normalized()
	
	move_heading(delta, targetDir, cruiseSpeed)
	
func move_in_dir(delta, speed):
	currentSpeed += (speed - currentSpeed) * accelPerc * delta
	
	var dir = Utils.rot_to_vec(get_rot())
	get_node(".").translate(dir * currentSpeed * delta)
	
	#ADAPT COLOR
	var r = get_modulate().r + (targetColor.r - get_modulate().r) * 20 * delta
	var g = get_modulate().g + (targetColor.g - get_modulate().g) * 20 * delta
	var b = get_modulate().b + (targetColor.b - get_modulate().b) * 20 * delta
	
	set_modulate(Color(r, g, b))
	
	
func move_to_player(delta, player):
	targetColor = Color(myColor, myColor, 1)
	var dirToPlayer = (player.get_pos() - get_pos()).normalized()
	move_heading(delta, dirToPlayer, followSpeed)

# Going to move 	
func move_heading(delta, headingVector, targetSpeed):
	var currRot = get_rot()
	var targetRot = Utils.vec_to_rot(headingVector)
	
	var rotDelta = Utils.rot_delta(currRot, targetRot)
	
	var rotChange = rotDelta * rotationSpeedPerc * delta
	
	var newRot = Utils.rot_norm(currRot + rotChange)
	
	set_rot(newRot)
	
	move_in_dir(delta, targetSpeed)

	
func check_disappear():
	var myPos = get_pos()
	var topLeft = Vector2(-10, -10)
	var rightBottom = Vector2(get_viewport_rect().size.x+10, get_viewport_rect().size.y+10)
	if !Utils.v2_aabb(myPos, topLeft.x, topLeft.y, rightBottom.x, rightBottom.y):
		shipDie()
		
		
func shipDie():
	get_parent().pool_ship(get_node("."))	
	