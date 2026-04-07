class_name PuzzleGenerator

@export var size_bounds := Vector2i(3,5)
@export var diff_bounds := Vector2i(1,1)
@export var allow_nostart := false
@export var require_solution_sprite := false

@export var debug_words : Array[String] = []
@export var debug_phonemes : Array[String] = [] # ["f", "ŭ", "n", "ē", "ŏ", "k", "r", "s", "b", "oo", "t", "ā", "w", "aw", "ī", "l", "m", "er", "h", "ă", "ĭ", "v", "ō", "ū"]

var solution : String
var phonemes : Array[String]

func generate() -> void:
	# read from file if we haven't yet
	if !Data.is_valid(): Data.read()
	
	PuzzleSettings.apply_difficulty_properties(self)

	var options := get_solution_options()
	if options.size() <= 0:
		print("PuzzleGenerator | Error | No phonemes available of size ", size_bounds)
		return
	
	solution = options.pick_random()
	phonemes = Data.get_word_phonemes(solution)

func get_solution_options() -> Array[String]:
	if debug_words.size() > 0: return debug_words
	
	# @TODO => @DEBUGGING: last argument should be require_solution_sprite
	var options_size := Data.get_all_of_size(size_bounds, allow_nostart, false)
	var options_diff := Data.get_all_of_difficulty(diff_bounds)
	var options := Data.get_union(options_size, options_diff)
	
	if debug_phonemes.size() > 0:
		options = Data.get_all_with_phonemes(Data.get_all_words(), debug_phonemes)
	
	return options

func count() -> int:
	return phonemes.size()
