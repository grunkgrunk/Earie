extends Area2D

export var melody = [13,12,13,14,15]



func send_melody(mel):
	if melody == mel:
		open()
	else:
		print("WRONG!!")
		pass


func open():
	print("OPEN!!")
	pass
