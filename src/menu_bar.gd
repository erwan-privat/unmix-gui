extends MenuBar

const SEP := "-"
const SK := "shortcut"
const CB := "callback"

var menu = {
	"Files": {
		"Open...": {
			SK: "open",
			CB: _on_files_open,
		},
		SEP: null,
		"Quit": {
			SK: "quit",
			CB: _on_files_quit,
		},	
	},
	"Help": {
		"GitHub page (web)": {
			SK: "github",
			CB: _on_help_github,
		},
		"About": {
			SK: "help",
			CB: _on_help_about,
		},
	},
}


func _ready() -> void:
	for m in menu:
		var pop := PopupMenu.new()
		pop.name = m

		var ix:= 0
		for key in menu[m]:
			if key == SEP:
				pop.add_separator()
			else:
				var sc = Shortcut.new()
				pop.add_item(key)
				# FIXME setup shortcuts
				#pop.set_item_shortcut(ix, Shortcut.new())
			++ix

		pop.index_pressed.connect(func (i: int):
			var sm = menu[m].keys()[i]
			menu[m][sm].callback.call()
		)
		%MenuBar.add_child(pop)


func _on_index_pressed(cat, index) -> void:
	print(cat, index)
	pass


func _on_files_open() -> void:
	var fd := FileDialog.new()
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILES
	fd.popup()


func _on_files_quit() -> void:
	get_node("/root/Main").quit()


func _on_help_github() -> void:
	pass

func _on_help_about() -> void:
	print("Made by Erwan Privat, more info on G")
