extends Node2D


onready var hand = $body/hand
onready var foot = $foot
onready var body = $body
onready var grab = $body/hand/grab

var holding = null
var hover = null
var foot_offset
var hand_offset
# Called when the node enters the scene tree for the first time.

func _ready():
	# $touch.connect("area_entered", self, "_on_touch_enter")
	# $touch.connect("area_exited", self, "_on_touch_exit")
	foot_offset =- foot.global_position +body.global_position
	hand_offset =- hand.global_position +body.global_position


func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var overlaps = $touch.get_overlapping_areas()
		for o in overlaps:
			if o.is_in_group("dragonball"): # draggable-ish
				print(o)
				holding = o
		# holding = hover
	
	if Input.is_action_just_released("left_click"):
		if holding == foot:
			body.global_position = holding.global_position + foot_offset
		if holding == hand:
			if grab.get_child_count() == 0:
				var overlaps = hand.get_overlapping_areas()
				for o in overlaps:
					print(o)
					if o.is_in_group("pick_up"):
						reparent(o, grab)
						o.position = Vector2()
			else:
				var obj = grab.get_child(0)
				reparent(obj, get_parent())
				obj.global_position = grab.global_position

			hand.global_position = body.global_position + hand_offset
						

		holding = null
	
	$touch.global_position = get_viewport().get_mouse_position() + $body/Camera2D.global_position - get_viewport_rect().size/2

	if holding != null:
		holding.global_position = $touch.global_position 



# func _on_touch_enter(obj):
# 	if obj.is_in_group("dragonball"): # draggable-ish
# 		hover = obj

# func _on_touch_exit(obj):
# 	hover = null


