extends PanelContainer


func _ready() -> void:
	%AbortBtn.pressed.connect(abort)
	%QuitBtn.pressed.connect(quit)

func _process(_delta):
	if Input.is_action_pressed("quit"):
		quit()


# Events #


func _on_source_browse() -> void:
	print("source open")


func _on_source_changed(path: String) -> void:
	print("source changed to ", path)


func _on_keepwav_toggle(state: bool) -> void:
	print("keep wav ", state)


func _on_wav_browse() -> void:
	print("wav browse")


func _on_wav_changed(path: String) -> void:
	print("wav changed to ", path)


func _on_dir_browse() -> void:
	print("dir browse")


func _on_dir_changed(path: String) -> void:
	print("dir changed to ", path)


func _on_unmix() -> void:
	unmix()


# Main functions #


func unmix() -> void:
	print("unmix")


func abort() -> void:
	print("abort")


func quit() -> void:
	print("quit")
	get_tree().quit()
