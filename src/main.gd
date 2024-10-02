extends PanelContainer


func _process(_delta):
	if Input.is_action_pressed("quit"):
		quit()
		
		
func quit() -> void:
	get_tree().quit()
