extends Sprite

# class member variables go here, for example:
export var speed = 100

export var direction = Vector2(0, 1)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	translate(direction * speed * delta)
	
	if get_pos().y > get_viewport_rect().size.y:
		get_parent().pool_star(get_node("."))