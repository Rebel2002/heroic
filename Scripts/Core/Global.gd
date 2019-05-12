extends Node

# Connection
# warning-ignore:unused_class_variable
var ip
# warning-ignore:unused_class_variable
var port = 10567

# Current character
# warning-ignore:unused_class_variable
var player: Dictionary

# Session
# warning-ignore:unused_class_variable
var players: Dictionary
# warning-ignore:unused_class_variable
var id

func modifier(attribute):
	return floor((attribute - 10) / 2)

func random(vector):
	if vector.x == vector.y:
		return vector.x
	else:
		return randi() % int(vector.y - vector.x) + vector.x