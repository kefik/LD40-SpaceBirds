extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	var myPos = get_pos()
	set_pos(myPos + Vector2(0, speed * delta))
	
	if get_pos().y > get_viewport_rect().size.y:
		get_node(".").queue_free()
