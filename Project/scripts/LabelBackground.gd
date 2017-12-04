extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var backgroundMarginX = 3
export var backgroundMarginY = 2

export var backgroundWidth = 100

export var textCharWidthMulti = 7.2

onready var background = get_node("./Background")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	
	
func _process(delta):
	var textSize = get_size();
	background.set_pos(Vector2(-backgroundMarginX, -backgroundMarginY))
	
	var sizeX = get_text().length() * textCharWidthMulti
	if backgroundWidth < sizeX + 2*backgroundMarginX:
		backgroundWidth = sizeX + 2*backgroundMarginX
	
	background.set_scale(Vector2(backgroundWidth, textSize.y+2*backgroundMarginY))
