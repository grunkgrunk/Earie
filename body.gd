extends Node2D

# TODO:
# fix shader screen resized


onready var hand = $body/hand
onready var foot = $foot
onready var body = $body
onready var grab = $body/hand/grab
onready var mouth = $body/mouth
onready var eye = $body/eye

var holding = null
var hover = null
var foot_offset
var hand_offset
var eye_offset
var singing = false
var last_note = 13
var melody = []
var n_notes = 6

func _ready():
	# $touch.connect("area_entered", self, "_on_touch_enter")
	# $touch.connect("area_exited", self, "_on_touch_exit")
	foot_offset =- foot.global_position +body.global_position
	hand_offset =- hand.global_position +body.global_position
	eye_offset =- eye.global_position +body.global_position


func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var overlaps = $touch.get_overlapping_bodies()
		for o in overlaps:
			if o.is_in_group("dragonball"): # draggable-ish
				print(o)
				holding = o
			elif o.is_in_group("mouth"):
				$shader.visible = true
				singing = true
				mouth.get_node("vocal").play()
				last_note = n_notes + round((get_viewport().get_mouse_position() - get_viewport_rect().size/2).y/(get_viewport_rect().size.y/2)*n_notes)
				melody = [last_note]
		# holding = hover
	
	if Input.is_action_just_released("left_click"):
		if singing:
			singing = false
			print(melody)
			send_melody(melody)
			melody = []
			$shader.visible = false
		if holding == foot:
			body.global_position = holding.global_position + foot_offset

		if holding == hand:
			if grab.get_child_count() == 0:
				var overlaps = hand.get_node('pickup').get_overlapping_areas()
				for o in overlaps:
					print(o)
					if o.is_in_group("pick_up"):
						reparent(o, grab)
						o.position = Vector2()
			else:
				var obj = grab.get_child(0)
				reparent(obj, get_parent())
				obj.global_position = grab.global_position

			hand.position = Vector2() - hand_offset

		if holding == eye:
			eye.position = Vector2()
			# $body/Camera2D.global_position = Vector2()


		holding = null
	
	$touch.global_position = get_viewport().get_mouse_position() + $body.global_position - get_viewport_rect().size/2

	
	if holding != null:
		# holding.global_position = $touch.global_position 
		holding.move_and_slide(($touch.global_position - holding.global_position)*10)	


	if singing:
		var note =  n_notes + round((get_viewport().get_mouse_position() - get_viewport_rect().size/2).y/(get_viewport_rect().size.y/2)*n_notes)
		mouth.get_node("vocal").pitch_scale = note/n_notes
		if not last_note == note:
			mouth.get_node("vocal").play()
			last_note = note
			melody.append(note)


# func _on_touch_enter(obj):
# 	if obj.is_in_group("dragonball"): # draggable-ish
# 		hover = obj

# func _on_touch_exit(obj):
# 	hover = null


func send_melody(mel):
	var overlaps = body.get_overlapping_areas()
	print("sang melody")
	for o in overlaps:
		if o.is_in_group("door"):
			print("Sent melody")

			o.send_melody(mel)
