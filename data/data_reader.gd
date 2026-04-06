extends Node
class_name DataReader

@export var file_path := "res://data/data.json"
@export var access_key := "words"
@export var access_key_phonemes := "phonemes"

var valid := false

var phonemes_data : Dictionary
var word_data : Dictionary
var words_by_phoneme_freq : Dictionary[int, Array]
var words_by_phoneme_used : Dictionary[String, Array]
var words_by_diff : Dictionary[int, Array]

func is_valid() -> bool:
	return valid

func get_all_phonemes() -> Array[String]:
	var arr : Array[String]
	arr.assign(phonemes_data.keys())
	return arr

func debug_missing_solutions() -> void:
	var missing : Array[String] = []
	for word in word_data:
		var path : String = get_word_sprite_path(word)
		var file := load(path)
		if not file: missing.append(path)
	missing.sort()
	
	for elem in missing:
		print("Debug | Missing Solution Sprite | " + elem)
	

func debug_missing_sounds() -> void:
	var missing : Array[String] = []
	for phoneme in phonemes_data:
		var path : String = get_phoneme_sound_path(phoneme)
		var file := load(path)
		if not file: missing.append(path)
	missing.sort()
	
	for elem in missing:
		print("Debug | Missing Sound | " + elem)

func debug_missing_sprites() -> void:
	var missing : Array[String] = []
	for phoneme in phonemes_data:
		var sprites = get_phoneme_sprites(phoneme)
		for sprite in sprites:
			var path : String = get_phoneme_sprite_path(sprite)
			var file := load(path)
			if not file:
				missing.append(path)
	missing.sort()
	
	for elem in missing:
		print("Debug | Missing Sprite | " + elem)

func read() -> void:
	# read actual file
	var json_as_text := FileAccess.get_file_as_string(file_path)
	var json_as_dict = JSON.parse_string(json_as_text)
	if not json_as_dict:
		print("Error | Can't read JSON file")
		return
	
	# save success
	valid = true
	word_data = json_as_dict[access_key] as Dictionary
	phonemes_data = json_as_dict[access_key_phonemes] as Dictionary
	words_by_phoneme_freq = {}
	
	# save some useful data structures for easy finding/accessing the exact words we want
	for key in word_data:
		var data = word_data[key]
		if "compound" in data: continue
		if not ("phonemes" in data): continue
		
		var num_phonemes : int = data.phonemes.size()
		if not (num_phonemes in words_by_phoneme_freq): words_by_phoneme_freq[num_phonemes] = []
		words_by_phoneme_freq[num_phonemes].append(key)
		
		for phoneme in data.phonemes:
			if not (phoneme in words_by_phoneme_used): words_by_phoneme_used[phoneme] = []
			words_by_phoneme_used[phoneme].append(key)
		
		var diff := 1
		if ("diff" in data): diff = data.diff
		if not (diff in words_by_diff): words_by_diff[diff] = []
		words_by_diff[diff].append(key)

# compound>?: bool
# syllables?: Array[String]
# phonemes?: Array[String
# diff?: int
func get_word_data(key:String) -> Dictionary:
	return word_data[key]

func get_word_phonemes(key:String) -> Array[String]:
	var arr : Array[String]
	arr.assign(get_word_data(key).phonemes)
	return arr

func get_word_sprite_path(key:String) -> String:
	return "res://phonemes/solutions/" + key + ".webp"

# sound?: String
# sprites?: Array[String]
func get_phoneme_data(key:String) -> Dictionary:
	return phonemes_data[key]

func get_phoneme_sound_path(key:String) -> String:
	return "res://phonemes/sounds/phoneme-" + get_phoneme_data(key).sound + ".ogg"

func get_phoneme_sprites(key:String) -> Array[String]:
	var arr : Array[String]
	arr.assign(get_phoneme_data(key).sprites)
	return arr

func get_phoneme_sprite_path(key:String) -> String:
	return "res://phonemes/sprites/" + key + ".webp"

func get_all_of_size(size_bounds:Vector2i, allow_nostart := false) -> Array[String]:
	var all_options : Array[String] = []
	for i in range(size_bounds.x, size_bounds.y + 1):
		if not (i in words_by_phoneme_freq): continue
		for elem in words_by_phoneme_freq[i]:
			if not allow_nostart and ("nostart" in get_word_data(elem)): continue
			all_options.append(elem as String)
	return all_options

func get_all_of_difficulty(diff_bounds:Vector2i) -> Array[String]:
	var all_options : Array[String] = []
	for i in range(diff_bounds.x, diff_bounds.y + 1):
		if not (i in words_by_diff): continue
		var arr : Array[String]
		arr.assign(words_by_diff[i])
		all_options += arr
	return all_options

func get_union(arr1:Array[String], arr2:Array[String]) -> Array[String]:
	return arr1.filter(func(elem:String): return arr2.has(elem))

func get_all_with_phonemes(list:Array[String], phonemes:Array[String]) -> Array[String]:
	var all_options : Array[String] = []
	for elem in list:
		var only_uses_legal_phonemes := true
		for phoneme in get_word_phonemes(elem):
			if phonemes.has(phoneme): continue
			only_uses_legal_phonemes = false
			break
		if not only_uses_legal_phonemes: continue
		all_options.append(elem)

	return all_options
