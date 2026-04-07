extends Node2D
class_name Decoration

@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

enum Type
{
	PLANET,
	STAR,
	METEOR,
	ROCKET,
	TEXTURE,
	MISC
}

var type := Type.PLANET
var tween_active : Tween

const FRAMES_FOR_TYPE : Dictionary[Type, Array] = {
	Type.PLANET: [0,1,2,3],
	Type.STAR: [4,5,6,7,8,9,10,11],
	Type.METEOR: [12,13],
	Type.ROCKET: [14,15],
	Type.TEXTURE: [16,17],
	Type.MISC: [18,19]
}

func set_random_type() -> void:
	set_type(Type.values().pick_random())

func get_frames() -> Array[int]:
	var frames : Array[int] = []
	frames.assign(FRAMES_FOR_TYPE[type])
	return frames

func set_type(tp:Type) -> void:
	type = tp
	sprite.set_frame(get_frames().pick_random())

func set_random_look(scale_bounds:Vector2, alpha_bounds:Vector2) -> void:
	modulate.a = randf_range(alpha_bounds.x, alpha_bounds.y)
	set_scale(Vector2.ONE * randf_range(scale_bounds.x, scale_bounds.y))
	set_rotation(randf() * 2 * PI)
	
	if type == Type.TEXTURE:
		scale *= 5.0
		modulate.a = 0.1
	
	if not PuzzleSettings.get_value("animate_background"): return
	
	if is_moving_type():
		pick_next_random_movement()
	
	if is_pulsating_type():
		anim_player.speed_scale = randf_range(0.33, 1.0)
		anim_player.play("pulsate")

func is_pulsating_type() -> bool:
	return [Type.STAR, Type.MISC].has(type)

func is_moving_type() -> bool:
	return [Type.PLANET, Type.ROCKET, Type.METEOR, Type.TEXTURE].has(type)

func is_non_rotating_type() -> bool:
	return [Type.TEXTURE].has(type)

func _exit_tree() -> void:
	if tween_active: tween_active.kill()

func pick_next_random_movement() -> void:
	if not is_non_rotating_type(): 
		set_rotation(randf() * 2 * PI)
	
	var dur := randf_range(5.0, 20.0)
	var offset := randf_range(50.0, 200.0)
	var tw := get_tree().create_tween()
	var new_position := position + Vector2.from_angle(rotation) * offset
	tw.tween_property(self, "position", new_position, dur)
	await tw.finished
	pick_next_random_movement()
	
