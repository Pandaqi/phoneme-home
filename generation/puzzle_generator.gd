class_name PuzzleGenerator

@export var size_bounds := Vector2i(3,5)
@export var diff_bounds := Vector2i(1,1)
@export var allow_nostart := false

@export var debug_words : Array[String] = ["bed"]

var solution : String
var phonemes : Array[String]

func generate() -> void:
	# read from file if we haven't yet
	if !Data.is_valid(): Data.read()
	
	Data.debug_missing_solutions()
	
	var options := get_solution_options()
	if options.size() <= 0:
		print("PuzzleGenerator | Error | No phonemes available of size ", size_bounds)
		return
	
	solution = options.pick_random()
	phonemes = Data.get_word_phonemes(solution)

func get_solution_options() -> Array[String]:
	if debug_words.size() > 0: return debug_words
	
	var options_size := Data.get_all_of_size(size_bounds, allow_nostart)
	var options_diff := Data.get_all_of_difficulty(diff_bounds)
	var options := Data.get_union(options_size, options_diff)
	return options
