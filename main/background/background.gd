extends CanvasLayer
class_name Background

@export var background_images_dark : Array[Texture2D]
@export var background_images_light : Array[Texture2D]
@export var texture_rect : TextureRect

@export var decoration_scene : PackedScene
var decorations : Array[Decoration] = []

var decoration_scale_bounds := Vector2(0.1, 0.35)
var alpha_bounds := Vector2(0.1, 0.425)

func _ready() -> void:
	pick_bg_texture()
	place_decoration()

func pick_bg_texture() -> void:
	texture_rect.texture = background_images_light.pick_random() if PuzzleSettings.get_value("light_mode") else background_images_dark.pick_random()

func place_decoration() -> void:
	var num_decoration := randi_range(30, 40)
	for i in range(num_decoration):
		var d : Decoration = decoration_scene.instantiate()
		d.set_position(get_random_position())
		add_child(d)
		d.set_random_type()
		d.set_random_look(decoration_scale_bounds, alpha_bounds)
		decorations.append(d)

func get_random_position() -> Vector2:
	return Vector2(randf(), randf()) * Vector2(1280, 720)
