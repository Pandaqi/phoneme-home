class_name PuzzleGenerator

@export var size_bounds := Vector2i(3,5)
@export var diff_bounds := Vector2i(1,1)
@export var allow_nostart := false
@export var require_solution_sprite := false

@export var debug_words : Array[String] = [] # ["green", "yellow", "black", "blue", "red"]
@export var debug_phonemes : Array[String] = [] # ["f", "ŭ", "n", "ē", "ŏ", "k", "r", "s", "b", "oo", "t", "ā", "w", "aw", "ī", "l", "m", "er", "h", "ă", "ĭ", "v", "ō", "ū"]

var solution : String
var phonemes : Array[String]
var all_solutions : Array[String]
## this is a faster/type-safe way to check for matching solutions, because each one is just its phonemes smushed together into a single string
var all_solutions_contatenated : Array[String] = []

func generate() -> void:
	# read from file if we haven't yet
	if !Data.is_valid(): Data.read()
	
	PuzzleSettings.apply_difficulty_properties(self)
	
	Data.debug_missing_solution_sounds()

	var options := get_solution_options()
	if options.size() <= 0:
		print("PuzzleGenerator | Error | No phonemes available of size ", size_bounds)
		return

	solution = options.pick_random()
	phonemes = Data.get_word_phonemes(solution)
	all_solutions = Data.get_all_words_with_phonemes(phonemes)
	
	all_solutions_contatenated = []
	for sol in all_solutions:
		all_solutions_contatenated.append("".join(Data.get_word_phonemes(sol)))

func get_solution_options() -> Array[String]:
	if debug_words.size() > 0: return debug_words
	
	var options_size := Data.get_all_of_size(size_bounds, allow_nostart, require_solution_sprite)
	var options_diff := Data.get_all_of_difficulty(diff_bounds)
	var options := Data.get_union(options_size, options_diff)
	print("PuzzleGenerator | Number of possible words at this level: ", options.size())
	
	if debug_phonemes.size() > 0:
		options = Data.get_all_with_phonemes(Data.get_all_words(), debug_phonemes)
	
	return options

func count() -> int:
	return phonemes.size()
