extends Node2D
class_name Main

@export var vis : PuzzleVisualizer
@export var tutorial : PuzzleTutorial

func _ready() -> void:
	var gen := PuzzleGenerator.new()
	gen.generate()
	vis.visualize(gen)
	
	var first_phoneme := vis.phonemes[0]
	var first_slot := vis.slots[0]
	tutorial.set_focus_objects([first_phoneme, first_slot])
	
	PuzzleFramework.start_puzzle()
	
