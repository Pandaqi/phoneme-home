extends Node2D
class_name PuzzleVisualizer

var generator : PuzzleGenerator

@export var phoneme_scene : PackedScene
var phonemes : Array[Phoneme] = []

var phoneme_selected : Phoneme

@export var debug := false
@export var label_debug : Label

func _ready() -> void:
	label_debug.set_visible(debug and OS.is_debug_build())

func visualize(gen:PuzzleGenerator) -> void:
	generator = gen
	label_debug.set_text(str(generator.solution))
	
	visualize_phonemes()
	visualize_slots()

func visualize_phonemes() -> void:
	for phoneme_string in generator.phonemes:
		var phoneme : Phoneme = phoneme_scene.instantiate()
		phoneme.set_position(get_random_position())
		phoneme.set_type(phoneme_string)
		phoneme.clicked.connect(_on_phoneme_clicked, CONNECT_APPEND_SOURCE_OBJECT)
		phonemes.append(phoneme)
		add_child(phoneme)

func visualize_slots() -> void:
	pass

func _on_phoneme_clicked(p:Phoneme) -> void:
	if phoneme_selected: phoneme_selected.deselect()
	phoneme_selected = p
	phoneme_selected.select()

func play_full_word() -> void:
	# @TODO: Really, the duration should depend on the phoneme ...
	# In JSON file, set an int (1/2/3/4) on how long a phoneme should take, and then just multiply that by a variable in here for customization?
	var time_between_phonemes := 0.15
	for phoneme in phonemes:
		phoneme.play_sound()
		await get_tree().create_timer(time_between_phonemes).timeout

func get_random_position() -> Vector2:
	return Vector2(randf(), randf()) * Vector2(1280, 720)

func _input(ev:InputEvent) -> void:
	if not debug: return
	if not OS.is_debug_build(): return
	if ev.is_action_released("ui_accept"):
		play_full_word()
