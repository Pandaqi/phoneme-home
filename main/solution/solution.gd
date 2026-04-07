extends Node2D
class_name SolutionVisualizer

@export var sprite : Sprite2D
@export var label : Label
@export var anim_player : AnimationPlayer
@export var audio_player : AudioStreamPlayer

var sprite_size := 128.0
var sprite_size_base := 512.0

signal finished()

func visualize(gen:PuzzleGenerator) -> void:
	var word_data := Data.get_word_data(gen.solution)
	
	# display the full word you made
	# (if multiple were possible, display all in comma-separated list)
	if gen.all_solutions.size() <= 1:
		label.set_text(gen.solution)
	else:
		label.set_text(", ".join(gen.all_solutions))
	
	# set custom sprite (if one specified)
	sprite.set_scale(Vector2.ONE * sprite_size / sprite_size_base)
	if "sprite" in word_data:
		sprite.texture = load(Data.get_solution_sprite_path(gen.solution))
	
	# play custom sound for full word (if one is available)
	if "sound" in word_data:
		audio_player.stream = load(Data.get_solution_sound_path(gen.solution))
		audio_player.play()
	
	# play animation to reveal stuff slowly
	anim_player.play("reveal")
	await anim_player.animation_finished
	finished.emit()
