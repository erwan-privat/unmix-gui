extends MenuBar
class_name Menu

const GITHUB := "https://github.com/erwan-privat/unmix-gui"

const SEP := &"-"
const SK := &"shortcut"
const CB := &"callback"

const AUDIO_FILTERS := [
		"*.*",
		"*.aac",
		"*.aiff",
		"*.caf",
		"*.flac",
		"*.m4a",
		"*.mp3",
		"*.ogg",
		"*.wav",
		"*.wma",
	]

var menu = {
	&"Files": {
		&"Open...": {
			SK: &"open",
			CB: _on_file_open,
		},
		# &"Open directory...": {
		# 	SK: &"open",
		# 	CB: _on_files_open_dir,
		# },
		SEP: null,
		&"Quit": {
			SK: &"quit",
			CB: _on_files_quit,
		},	
	},
	&"Languages": {
		&"English": {
			SK: &"en",
			CB: func(): _on_lang(&"en"),
		},
		&"Français": {
			SK: &"fr",
			CB: func(): _on_lang(&"fr"),
		},
	},
	&"Help": {
		&"GitHub page...": {
			SK: &"github",
			CB: _on_help_github,
		},
	},
}


func _ready() -> void:
	for m in menu:
		var pop := PopupMenu.new()
		pop.name = m

		#var ix:= 0
		for key in menu[m]:
			if key == SEP:
				pop.add_separator()
			else:
				
				pop.add_item(key)
				# FIXME setup shortcuts
				#var sc = Shortcut.new()
				#pop.set_item_shortcut(ix, Shortcut.new())

		pop.index_pressed.connect(func (i: int):
			var sm = menu[m].keys()[i]
			menu[m][sm].callback.call()
		)
		add_child(pop)


func _on_file_open() -> void:
	var fd := FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fd.set_filters(AUDIO_FILTERS)
	fd.file_selected.connect(_on_file_selected)
	fd.popup()


# func _on_files_open_dir() -> void:
# 	var fd := FileDialog.new()
# 	fd.access = FileDialog.ACCESS_FILESYSTEM
# 	fd.file_mode = FileDialog.FILE_MODE_OPEN_DIR
# 	fd.dir_selected.connect(_on_dir_selected)
# 	fd.popup()


func _on_files_quit() -> void:
	$/root/Main.quit()


func _on_lang(lang: StringName) -> void:
	print("Changing language to ", lang)

func _on_help_github() -> void:
	OS.shell_open(GITHUB)


func _on_file_selected(path: String) -> void:
	print(path)
