extends Node2D
class_name Slot

@export var sprite : Sprite2D
@export var sprite_bg : Sprite2D
@export var area : Area2D
@export var col_shape : CollisionShape2D
@export var audio_assigned : AudioStreamPlayer2D

var base_size := 256.0
var content : Phoneme

signal clicked()

func _ready() -> void:
	area.input_event.connect(_on_input_event)
	
	sprite.set_frame(0)
	sprite_bg.set_frame(1)
	
	if PuzzleSettings.get_value("light_mode"):
		sprite.set_frame(2)
		sprite_bg.set_frame(3)

func set_size(new_size:float) -> void:
	var new_scale := new_size / base_size * Vector2.ONE
	sprite.set_scale(new_scale)
	sprite_bg.set_scale(new_scale)
	col_shape.shape.size = new_size * Vector2.ONE

func _on_input_event(_vp:Node, ev:InputEvent, _sidx:int) -> void:
	if not (ev is InputEventMouseButton or ev is InputEventScreenTouch): return
	if ev.is_pressed(): return
	clicked.emit()

func has_content() -> bool:
	return content != null

func set_content(p:Phoneme) -> void:
	reset()
	content = p
	PuzzleAudio.play_audio_nice(audio_assigned)
	await p.put_into_slot(self)

func reset() -> void:
	if not has_content(): return
	PuzzleAudio.play_audio_nice(audio_assigned)
	var old_content := content
	content = null
	await old_content.push_out_of_slot()

func highlight() -> void:
	# @TODO
	pass

func unhighlight() -> void:
	pass
