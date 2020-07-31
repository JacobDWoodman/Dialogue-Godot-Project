extends RichTextLabel

export(String, FILE, "*.json") var file_path

var NameTag
var CharIcon
onready var dialogue : Array = load_dialogue(file_path)
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	NameTag = get_parent().get_child(0)
	CharIcon = get_parent().get_parent().get_child(0).get_child(1)
	update_talk()
	set_process_input(true)

func _input(_event):
	if Input.is_action_just_pressed("select"):
		if get_visible_characters() >= get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				update_talk()
		else: 
			set_visible_characters(get_total_character_count())
			end_talking()

func update_talk():
	set_bbcode(dialogue[page]['line'])
	NameTag.text = dialogue[page]['name']
	CharIcon.play(dialogue[page]['expression']+" Speak")
	set_visible_characters(0)

func end_talking():
	CharIcon.play(dialogue[page]['expression'])

func load_dialogue(f_path):
	var file = File.new()
	file.open(f_path, file.READ)
	var text = parse_json(file.get_as_text())
	return text

func _on_Timer_timeout():
	if get_visible_characters() < get_total_character_count():
		set_visible_characters(get_visible_characters() + 1)
	else: end_talking()
