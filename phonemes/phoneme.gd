extends Node2D
class_name Phoneme

@export var sprite : Sprite2D
@export var area : Area2D
@export var audio_player : AudioStreamPlayer

var phoneme : String
var sprite_keys : Array[String]
var cycle_sprites := true
var cycle_sprite_index := 0

signal clicked()
signal sound_finished()

func _ready() -> void:
	area.input_event.connect(_on_input_event)

func set_type(ph:String) -> void:
	phoneme = ph
	
	sprite_keys = Data.get_phoneme_sprites(phoneme)
	cycle_sprite_index = randi() % sprite_keys.size()
	refresh_sprite()

func _on_input_event(_vp:Node, ev:InputEvent, _sidx:int) -> void:
	if not (ev is InputEventMouseButton or ev is InputEventScreenTouch): return
	if ev.is_pressed(): return
	play_sound()
	cycle_sprite()
	clicked.emit()

func select() -> void:
	set_scale(Vector2.ONE*1.2)

func deselect() -> void:
	set_scale(Vector2.ONE)

func cycle_sprite() -> void:
	if not cycle_sprites: return
	cycle_sprite_index = (cycle_sprite_index + 1) % sprite_keys.size()
	refresh_sprite()

func refresh_sprite() -> void:
	sprite.texture = load(Data.get_phoneme_sprite_path(sprite_keys[cycle_sprite_index]))

func play_sound() -> void:
	audio_player.stream = load(Data.get_phoneme_sound_path(phoneme))
	audio_player.play()
	await audio_player.finished
	sound_finished.emit()
