extends PopupMenu

var menu_actions = {
	"Open...": _on_open_dialog,
	"-": null,
	"Quit": _on_quit,
}

func _ready() -> void:
	for lbl in menu_actions:
		if lbl == "-":
			add_separator()
		else:
			add_item(lbl)
	
	index_pressed.connect(_on_index_pressed)
	$Open.files_selected.connect(_on_open)


func _on_index_pressed(index) -> void:
	menu_actions[menu_actions.keys()[index]].call()


func _on_open_dialog() -> void:
	$Open.popup()


func _on_open(path) -> void:
	print(path)


func _on_quit() -> void:
	get_node("/root/Main").quit()
