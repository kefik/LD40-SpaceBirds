extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var ship_proto = preload("res://small_ship.tscn")

export var spawn_time = 3

export var spawn_time_rand = 0.5

export var currTime = 0.5

var shipCount = 0

var shipSpread = 60

var pool = []

func _ready():
	set_process(true)
	
func _process(delta):
	currTime -= delta
	if currTime < 0:		
		currTime += spawn_time + randf() * spawn_time_rand
		
		spawn_time *= 0.98
		spawn_time_rand *= 0.99
		
		var limit = 0.5
		if shipCount > 500:
			limit = 0.2
		elif shipCount > 400:
			limit = 0.3
		elif shipCount > 300:
			limit = 0.4
		elif shipCount > 200:
			limit = 0.45
		elif shipCount > 100:
			limit = 0.48		
		if spawn_time < limit:
			spawn_time = limit
		
		
		var ship = null
		if pool.size() == 0:
			ship = ship_proto.instance()
		else:
			ship = pool[pool.size()-1]
			pool.pop_back()
		
		#POSITION
		var width = int(Globals.get("display/width"))
		
		if shipCount == 0:
			ship.set_pos(Vector2(width/2, -9.9))	
			ship.set_rot(-PI/2)		
		if  shipCount < 8:
			ship.set_pos(Vector2(width / 2 - shipSpread / 2 + randi()%(shipSpread), -9.9))			
			ship.set_rot(-PI/2)
		else:			
			var spawnX = width / 2 - shipSpread / 2 + randi()%(shipSpread)
			var spawnY = 0
			if shipCount % 2 == 0:
				ship.set_pos(Vector2(spawnX, get_viewport_rect().size.y+9.9))
				ship.set_rot(PI/2)
			else:
				ship.set_pos(Vector2(spawnX, -9.9))
				ship.set_rot(-PI/2)
				
		shipSpread += 30
		if shipSpread > get_viewport_rect().size.x - 120:
			shipSpread -= 30
			
		shipCount += 1
		
		ship.set_fixed_process(true)	
		add_child(ship)
		
		#SETTINGS
		ship.reactionDistance += randf() * -30
		ship.rotationSpeedPerc = 1.8
		ship.rotationSpeedPerc -= randf() * 0.6
		
		# ship.followSpeed += -20 + randf() * 60 
		
func pool_ship(ship):
	pool.push_back(ship)
	get_node(".").remove_child(ship)
	get_node("/root/Game/UI").playerEnergy -= 1
	ship.set_fixed_process(false)	
		
	