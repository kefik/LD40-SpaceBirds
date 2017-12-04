extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 10;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	if (Input.is_action_pressed("down")):
		get_node(".").translate(Vector2(0,1) * speed * delta)
	if (Input.is_action_pressed("up")):
		get_node(".").translate(Vector2(0,-1) * speed * delta)
	if (Input.is_action_pressed("left")):
		get_node(".").translate(Vector2(-1,0) * speed * delta)
	if (Input.is_action_pressed("right")):
		get_node(".").translate(Vector2(1,0) * speed * delta)
