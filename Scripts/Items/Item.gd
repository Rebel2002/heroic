extends Area2D

export(int) var stack = 1
export(int) var count = 1

sync func pick():
	queue_free()

func stackable():
	return stack != 1