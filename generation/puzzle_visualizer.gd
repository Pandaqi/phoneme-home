extends Node2D
class_name PuzzleVisualizer

var generator : PuzzleGenerator
var commands : PuzzleCommands

@export var phoneme_scene : PackedScene
var phonemes : Array[Phoneme] = []

@export var slot_scene : PackedScene
var slots : Array[Slot] = []

@export var solution_visualizer : SolutionVisualizer

@export var use_text_to_speech := false

var busy := false
var solved := false

var phoneme_dragging : Phoneme
var phoneme_selected : Phoneme
@export var element_size := 128.0

@export var spaceship : Node2D

@export var debug := false
@export var label_debug : Label

func _ready() -> void:
	label_debug.set_visible(debug and OS.is_debug_build())
	solution_visualizer.finished.connect(_on_solution_visualization_finished)

func count() -> int:
	return slots.size()

func visualize(gen:PuzzleGenerator) -> void:
	generator = gen
	label_debug.set_text(str(generator.solution))
	spaceship.hide()
	
	visualize_slots()
	visualize_phonemes()
	
	commands = PuzzleCommands.new()
	commands.prepare_for_play()
	
	var solution : Array[PuzzleCommand] = []
	for i in range(count()):
		solution.append(CommandTurn.new(phonemes[i], slots[i], self))
	commands.set_solution(solution)
	
	if PuzzleSettings.get_value("show_image_hint"):
		solution_visualizer.visualize(generator, true)

func visualize_phonemes() -> void:
	var vp := Vector2(1280, 720)
	var grid_size := Vector2i((vp / element_size).floor())
	var center_pos_grid := (0.5 * Vector2(grid_size)).floor()
	var grid_positions : Array[Vector2i] = []
	for x in range(1, grid_size.x):
		for y in range(grid_size.y - 1):
			if y == center_pos_grid.y: continue
			grid_positions.append(Vector2i(x,y))
	grid_positions.shuffle()
	
	# calculate distance between REAL center (where slots are placed) and GRID center
	# so we can align this grid with the slots
	var grid_offset := 0.5 * vp - center_pos_grid * element_size
	
	for phoneme_string in generator.phonemes:
		var phoneme : Phoneme = phoneme_scene.instantiate()
		var grid_pos : Vector2i = grid_positions.pop_back()
		var real_pos := Vector2(grid_pos) * element_size + grid_offset
		phoneme.set_position(real_pos)
		phoneme.set_type(phoneme_string)
		phoneme.set_size(element_size)
		phoneme.click_started.connect(_on_phoneme_click_started, CONNECT_APPEND_SOURCE_OBJECT)
		phoneme.clicked.connect(_on_phoneme_clicked, CONNECT_APPEND_SOURCE_OBJECT)
		phonemes.append(phoneme)
		add_child(phoneme)

func visualize_slots() -> void:
	var num_slots := generator.count()
	var offset := -0.5 * (num_slots - 1) * Vector2.RIGHT * element_size
	
	var vp_center := 0.5 * Vector2(1280, 720)
	
	for i in range(num_slots):
		var s : Slot = slot_scene.instantiate()
		s.set_position(vp_center + offset + i * element_size * Vector2.RIGHT)
		s.set_size(element_size)
		s.clicked.connect(_on_slot_clicked, CONNECT_APPEND_SOURCE_OBJECT)
		slots.append(s)
		add_child(s)

func _on_phoneme_click_started(p:Phoneme) -> void:
	if not PuzzleSettings.get_value("allow_drag_drop"): return
	phoneme_dragging = p
	select_phoneme(p)

func _physics_process(_dt:float) -> void:
	if not phoneme_dragging: return
	phoneme_dragging.set_position(get_global_mouse_position())

func _on_slot_clicked(s:Slot) -> void:
	if not phoneme_selected: return
	if is_busy(): return
	var cmd := CommandTurn.new(phoneme_selected, s, self)
	commands.execute_command(cmd)

func is_busy() -> bool:
	return busy or commands.is_busy() or solved

func reset_phoneme_selected() -> void:
	if not phoneme_selected: return
	phoneme_selected.deselect()
	phoneme_selected = null

func select_phoneme(p:Phoneme) -> void:
	reset_phoneme_selected()
	phoneme_selected = p
	if not phoneme_selected: return
	phoneme_selected.select()

func _on_phoneme_clicked(p:Phoneme) -> void:
	if PuzzleSettings.get_value("allow_drag_drop"): return
	select_phoneme(p)

func play_full_word(correct := false) -> void:
	var phonemes_to_play : Array[Phoneme] = []
	for slot in slots:
		if not slot.has_content(): continue
		phonemes_to_play.append(slot.content)
	
	if correct: phonemes_to_play = phonemes
	
	var total_duration := 0.0
	for phoneme in phonemes_to_play:
		total_duration += phoneme.get_sound_duration()
		total_duration += phoneme.get_tween_duration()
	
	var vp := Vector2(1280, 720)
	var spaceship_y := 0.5*vp.y + 0.75 * element_size
	spaceship.set_position(Vector2(0, spaceship_y))
	spaceship.show()
	var tw := get_tree().create_tween()
	tw.tween_property(spaceship, "position", Vector2(vp.x, spaceship_y), total_duration)
	tw.tween_callback(spaceship.hide)
	
	# @NOTE: if used, also turn on the project setting for it
	if use_text_to_speech:
		var voices := DisplayServer.tts_get_voices_for_language("en")
		if voices.size() > 0:
			var txt := "".join( phonemes_to_play.map(func(p:Phoneme): return p.get_tts_string()) )
			var voice_id := voices[0]
			DisplayServer.tts_speak(txt, voice_id)
			return
	
	for phoneme in phonemes_to_play:
		phoneme.play_sound()
		if phoneme.slot_assigned: phoneme.slot_assigned.highlight()
		#await phoneme.sound_finished
		await get_tree().create_timer(phoneme.get_sound_duration()).timeout
		if phoneme.slot_assigned: phoneme.slot_assigned.unhighlight()

func get_random_position() -> Vector2:
	return Vector2(randf(), randf()) * Vector2(1280, 720)

func mark_correct_solution() -> bool:
	# turn solution into concatenated string of phonemes
	var solution_string := ""
	for i in range(slots.size()):
		if not slots[i].has_content(): 
			solution_string += " "
			continue
		solution_string += slots[i].content.phoneme
	
	# check if this is part of any solution
	var is_correct := generator.all_solutions_contatenated.has(solution_string)
	
	# now mark each individual one as correct or wrong
	# (if we already know we're correct, even on an alternative word, just mark all correct)
	for i in range(slots.size()):
		if not slots[i].has_content(): continue
		
		var phoneme_in_slot := slots[i].content
		if phoneme_in_slot.phoneme == phonemes[i].phoneme or is_correct:
			await phoneme_in_slot.mark_correct()
			continue
		await phoneme_in_slot.mark_wrong()

	return is_correct

func reset_slots() -> void:
	for slot in slots:
		slot.reset()
	commands.clear()

func check_if_word_completed() -> void:
	var empty_slots := slots.filter(func(s:Slot): return not s.has_content())
	if empty_slots.size() > 0: return
	
	print("Word Completed -> Start Playing/Checking")
	await get_tree().create_timer(0.3).timeout
	await play_full_word()
	
	var is_correct := await mark_correct_solution()
	print("Checked Word -> Correct? ", is_correct)
	
	solved = false
	if is_correct:
		# @NOTE: this plays some animations, 
		# then sends a signal that will finish the puzzle for good
		solved = true
		solution_visualizer.visualize(generator)
		return
	
	reset_slots()

func _on_solution_visualization_finished() -> void:
	if not solved: return
	PuzzleFramework.finish_puzzle(true)

func _input(ev:InputEvent) -> void:
	if not debug: return
	if not OS.is_debug_build(): return
	if ev.is_action_released("ui_accept"):
		play_full_word(true)
