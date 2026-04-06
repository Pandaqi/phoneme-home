extends Node2D
class_name Main

@export var vis : PuzzleVisualizer

func _ready() -> void:
	var gen := PuzzleGenerator.new()
	gen.generate()
	vis.visualize(gen)
	
	
