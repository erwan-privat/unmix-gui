extends PanelContainer
class_name Main


const SLASH := "/"
const DOT := "."
const WAV := "wav"
const SUBDIR := "unmix"

const CFG_PATH := "user://config.ini"
const CFG_LANG := "lang"
const CFG_LAST := "last_source"
const CFG_KEEP := "keep_wav"


func _ready() -> void:
	get_viewport().files_dropped.connect(_on_files_dropped)
	%AbortBtn.pressed.connect(abort)
	%QuitBtn.pressed.connect(quit)
	load_settings()


func _process(_delta):
	if Input.is_action_pressed("quit"):
		quit()


func _notification(what):
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			print("close request")
			save_settings()
			get_tree().quit()
		Node.NOTIFICATION_DRAG_BEGIN:
			print("drag begin")
		Node.NOTIFICATION_DRAG_END:
			print("drag end")


# Events #


func _on_files_dropped(paths: PackedStringArray) -> void:
	print("dropped ", paths)
	if paths.size() > 1:
		error(tr("Only drop one file"))
		return

	_on_source_changed(paths[0])


func _on_source_browse() -> void:
	print("source open")
	_on_browse(FileDialog.FILE_MODE_OPEN_FILE,
			_on_source_changed)


func _on_source_changed(path: String) -> void:
	print("source changed to ", path)
	if path.is_empty():
		%SourceTxt.text = ""
		%WavPathTxt.text = ""
		%DirPathTxt.text = ""
		return
		
	var seg := get_dir_name_ext(path)
	var dir := seg[0]
	var fna := seg[1]
	# var ext := seg[2]

	%SourceTxt.text = path
	%WavPathTxt.text = dir + SLASH + fna + DOT + WAV
	%DirPathTxt.text = dir + SLASH + fna + SLASH + SUBDIR


func _on_keepwav_toggle(state: bool) -> void:
	print("keep wav ", state)


func _on_wav_browse() -> void:
	print("wav browse")
	_on_browse(FileDialog.FILE_MODE_OPEN_FILE,
			_on_wav_changed)


func _on_wav_changed(path: String) -> void:
	print("wav changed to ", path)
	%WavPathTxt.text = path


func _on_dir_browse() -> void:
	print("dir browse")
	_on_browse(FileDialog.FILE_MODE_OPEN_DIR,
			_on_dir_changed)


func _on_dir_changed(path: String) -> void:
	print("dir changed to ", path)
	%DirPathTxt.text = path


func _on_browse(mode: FileDialog.FileMode,
		callback: Callable) -> void:

	var fd := FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.file_mode = mode
	
	var sig: Signal
	if mode == FileDialog.FILE_MODE_OPEN_FILE:
		sig = fd.file_selected
	elif mode == FileDialog.FILE_MODE_OPEN_DIR:
		sig = fd.dir_selected
	else:
		error("Wrong file mode sent")
	
	sig.connect(callback)
	fd.popup()


func _on_unmix() -> void:
	unmix()


# Main functions #


func save_settings() -> void:
	print("save settings")
	var cf := ConfigFile.new()
	cf.set_value("", CFG_LANG, TranslationServer.get_locale())
	cf.set_value("", CFG_LAST, %SourceTxt.text)
	cf.set_value("", CFG_KEEP, %KeepWavBtn.button_pressed)
	cf.save(CFG_PATH)


func load_settings() -> void:
	print("load settings")
	var cf := ConfigFile.new()
	cf.load(CFG_PATH)
	TranslationServer.set_locale(cf.get_value("", CFG_LANG))
	var last = cf.get_value("", CFG_LAST)
	var keep = cf.get_value("", CFG_KEEP)
	%SourceTxt.text = last if last != null else ""
	_on_source_changed(%SourceTxt.text)
	%KeepWavBtn.button_pressed = keep if keep != null else false


## Return an array containing the conversion from the string
## "/full/path/filename.ext" to ["/full/path", "filename",
## "ext"]
func get_dir_name_ext(path: String) -> Array[String]:
	var segments := path.split(SLASH)
	var dir := SLASH.join(segments.slice(0, -1))
	var fn_seg := segments[-1].split(DOT)
	var fn := DOT.join(fn_seg.slice(0, -1))
	var ext := fn_seg[-1]
	return [dir, fn, ext]


func unmix() -> void:
	var src_path = %SourceTxt.text
	var wav_path = %WavPathTxt.text
	var dir_path = %DirPathTxt.text

	if not (src_path and wav_path and dir_path) \
			or src_path == "" \
			or wav_path == "" \
			or dir_path == "":
		error("Invalid paths to unmix")
		return

	var params := [src_path, wav_path, dir_path]
	var output: Array[String]

	print("executing unmix with params ", params)
	OS.execute("./umx.sh", params, output, true)
	%Console.text = output[0]


func error(msg: String) -> void:
	printerr(msg)
	OS.alert(msg)


func abort() -> void:
	print("abort")


func quit() -> void:
	print("quit")
	get_tree().root.propagate_notification(
			NOTIFICATION_WM_CLOSE_REQUEST)
