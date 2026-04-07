extends Node2D
class_name WavesEffect

var wave_radii : Array[float] = []
var growth_speed := 700.0
var max_size := 300.0
var alpha_bounds := Vector2(0.75, 0.0)

var color := Color.WHITE
var width := 2.0

func add_wave(start_offset := 0.0) -> void:
	wave_radii.append(start_offset)

func count() -> int:
	return wave_radii.size()

func _physics_process(dt:float) -> void:
	if count() <= 0: return
	
	for i in range(count() -1, -1, -1):
		var new_val := wave_radii[i] + growth_speed * dt
		wave_radii[i] = new_val
		if new_val >= max_size:
			wave_radii.remove_at(i)
	queue_redraw()

func _draw() -> void:
	for i in range(count()):
		var radius := wave_radii[i]
		if radius <= 0: continue
		var col := color
		col.a = lerpf(alpha_bounds.x, alpha_bounds.y, radius / max_size)
		draw_circle(Vector2.ZERO, radius, col, false, width, true)
