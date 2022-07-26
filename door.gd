extends Area2D

export var melody = [14,13,14,15,16]

func send_melody(mel):
	var tf = check_melody(mel)

	if tf:
		open()
	else:
		print("Wrong!!")
func check_melody(mel):
	if len(mel) != len(melody):
		return false
	for m in range(len(mel)):
		if mel[m] != melody[m]:
			return false
	return true
	


func open():
	print("OPEN!!")
	get_parent().queue_free()
