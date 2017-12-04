extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var score = 0
var time = 0

onready var scoreText = get_node("./Score")
onready var timeText = get_node("./Time")
onready var restartBtn = get_node("./Restart")

var game = preload("res://game.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _process(delta):
	scoreText.text = "Score: %.1f" % [ score ]
	timeText.text = "Time: %.1f" % [ time ]
	
	if restartBtn.is_pressed():
		restart()
		
func restart():
	set_process(false)
	var oldGame = get_node("/root/Game")
	oldGame.set_name("old")
	oldGame.queue_free()
	get_node("/root").add_child(game.instance())
	
