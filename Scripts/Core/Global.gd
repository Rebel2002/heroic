extends Node

# Connection
var ip
var port = 10567

# Current character
var player = {}

# Session
var players = {}
var id

func modifier(attribute):
	return floor((attribute - 10) / 2)