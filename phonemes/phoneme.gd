extends Node2D
class_name Phoneme

@export var visuals_container : Node2D
@export var sprite : Sprite2D
@export var sprite_flash : Sprite2D
@export var sprite_bg : Sprite2D

@export var area : Area2D
@export var col_shape : CollisionShape2D
@export var audio_player : AudioStreamPlayer

@export var display_letter := true
@export var label : Label

@export var waves_effect : WavesEffect
@export var squasher_stretcher : SquasherStretcher

var phoneme : String
var sprite_keys : Array[String]
@export var cycle_sprites := false
var cycle_sprite_index := 0

var size := 0.0
var base_size := 512.0
var slot_assigned : Slot
var start_pos := Vector2.ZERO
var hovering := false
var selected := false

const BG_FRAME_REGULAR := 0
const BG_FRAME_SELECTED := 1
const BG_FRAME_CORRECT := 2

signal clicked()
signal click_started()
signal sound_finished()

func _ready() -> void:
	area.input_event.connect(_on_input_event)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	start_pos = get_position()

func set_type(ph:String) -> void:
	phoneme = ph
	
	label.hide()
	label.set_text(phoneme.to_upper())
	
	sprite_keys = Data.get_phoneme_sprites(phoneme)
	cycle_sprite_index = randi() % sprite_keys.size()
	refresh_sprite()
	
	sprite.hide()
	if PuzzleSettings.get_value("show_letter"):
		label.show()
	else:
		sprite.show()

func get_tts_string() -> String:
	var data := Data.get_phoneme_data(phoneme)
	if "tts" in data: return data.tts
	return phoneme

func _on_input_event(_vp:Node, ev:InputEvent, _sidx:int) -> void:
	if not (ev is InputEventMouseButton or ev is InputEventScreenTouch): return
	if ev.is_pressed():
		click_started.emit()
		return
	if is_inside_slot(): 
		play_sound()
		return
	clicked.emit()

func _on_mouse_entered() -> void:
	if is_inside_slot(): return
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false

func select() -> void:
	play_sound()
	cycle_sprite()
	sprite_bg.set_frame(BG_FRAME_SELECTED)
	selected = true

func deselect() -> void:
	sprite_bg.set_frame(BG_FRAME_REGULAR)
	selected = false

func _physics_process(dt:float) -> void:
	var new_scale := size / base_size * Vector2.ONE
	var target_scale_bg := new_scale * 2.5
	var target_scale := new_scale * 0.5
	var target_rotation := 0.0
	sprite_flash.hide()
	if hovering or selected: 
		target_scale_bg = new_scale * 3.0
		target_rotation = 0.05*PI
		sprite_flash.show()
	if selected:
		#target_scale = new_scale * 0.25
		target_rotation *= -1
	
	var smooth_speed := 12 * dt
	sprite_bg.set_scale(sprite_bg.scale.lerp(target_scale_bg, smooth_speed))
	sprite.set_rotation(lerp(sprite.rotation, target_rotation, smooth_speed))
	sprite.set_scale(sprite.scale.lerp(target_scale, smooth_speed))

func set_size(new_size:float) -> void:
	size = new_size
	col_shape.shape.size = size * Vector2.ONE

func cycle_sprite() -> void:
	if not cycle_sprites: return
	cycle_sprite_index = (cycle_sprite_index + 1) % sprite_keys.size()
	refresh_sprite()

func refresh_sprite() -> void:
	sprite.texture = load(Data.get_phoneme_sprite_path(sprite_keys[cycle_sprite_index]))
	sprite_flash.texture = sprite.texture

func mark_correct() -> void:
	sprite_bg.set_frame(BG_FRAME_CORRECT)
	var tw := PuzzleTween.play_jump_tween(visuals_container)
	await tw.finished

func mark_wrong() -> void:
	sprite_bg.set_frame(BG_FRAME_REGULAR) # @TODO: A BAD frame? Not really needed, is it?
	var tw := PuzzleTween.play_shake_tween(visuals_container)
	await tw.finished

func play_sound() -> void:
	if PuzzleSettings.get_value("sound_waves"):
		var num_waves := randi_range(1,3)
		waves_effect.color = Color.BLACK if PuzzleSettings.get_value("light_mode") else Color.WHITE
		for i in range(num_waves):
			waves_effect.add_wave(-i * 0.06 * waves_effect.growth_speed)
	
	audio_player.stream = load(Data.get_phoneme_sound_path(phoneme))
	audio_player.play()
	await audio_player.finished
	sound_finished.emit()

func get_sound_duration() -> float:
	return Data.get_phoneme_duration(phoneme)

func get_tween_duration() -> float:
	return 0.2

func is_inside_slot() -> bool:
	return slot_assigned != null

func push_out_of_slot() -> void:
	slot_assigned = null
	squasher_stretcher.set_paused(false)
	
	var tw := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var dur := randf_range(0.1, 0.25)
	tw.tween_property(self, "position", start_pos, dur)
	await tw.finished

func put_into_slot(s:Slot) -> void:
	slot_assigned = s
	squasher_stretcher.set_paused(true)
	
	var target_pos := s.get_position()
	var tw := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var dur := randf_range(0.1, 0.25)
	tw.tween_property(self, "position", target_pos, dur)
	await tw.finished
