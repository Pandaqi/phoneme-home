extends PuzzleCommand
class_name CommandTurn

var phoneme : Phoneme
var slot : Slot
var vis : PuzzleVisualizer

var old_content : Phoneme
var old_selected : Phoneme
var old_dragging : Phoneme

func _init(p:Phoneme, s:Slot, v:PuzzleVisualizer) -> void:
	phoneme = p
	slot = s
	vis = v
	starts_new_turn = true

func do(_cmds:PuzzleCommands) -> bool:
	old_content = slot.content
	await slot.set_content(phoneme)
	
	old_selected = vis.phoneme_selected
	vis.reset_phoneme_selected()
	
	old_dragging = vis.phoneme_dragging
	vis.phoneme_dragging = null
	
	vis.check_if_word_completed()
	return true

func undo(_cmds:PuzzleCommands) -> bool:
	vis.phoneme_dragging = old_dragging
	vis.select_phoneme(old_selected)
	await slot.set_content(old_content)
	return true

func matches(cmd:PuzzleCommand) -> bool:
	if not (cmd is CommandTurn): return false
	return cmd.phoneme == phoneme and cmd.slot == slot
