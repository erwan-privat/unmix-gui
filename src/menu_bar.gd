extends MenuBar

var menu = {
	"Files": {
		"Open...": _on_files_open,
		"-": null,
		"Quit": _on_files_quit,
		},
	"Help": {
		"GitHub page (web)": _on_help_github,
		"About": _on_help_about,
	},
}


func _ready() -> void:
	pass


func _on_index_pressed(cat, index) -> void:
	


func _on_files_open() -> void:
	$Files/Open.popup()


func _on_files_quit() -> void:
	get_node("/root/Main").quit()


func _on_help_github() -> void:
	pass

func _on_help_about() -> void:
	print("Made by Erwan Privat, more info on G")
