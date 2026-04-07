extends Node2D
class_name SolutionVisualizer

@export var sprite : Sprite2D
@export var label : Label
@export var anim_player : AnimationPlayer

var sprite_size := 128.0
var sprite_size_base := 512.0

signal finished()

func visualize(gen:PuzzleGenerator) -> void:
	label.set_text(gen.solution)
	
	var word_data := Data.get_word_data(gen.solution)
	sprite.set_scale(Vector2.ONE * sprite_size / sprite_size_base)
	if "sprite" in word_data:
		sprite.texture = load("res://phonemes/solutions/" + word_data.sprite + ".webp")
	
	anim_player.play("reveal")
	await anim_player.animation_finished
	finished.emit()
