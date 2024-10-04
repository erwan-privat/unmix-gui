extends PanelContainer


const SLASH = "/"
const DOT = "."
const WAV = "wav"


func _ready() -> void:
	%AbortBtn.pressed.connect(abort)
	%QuitBtn.pressed.connect(quit)

func _process(_delta):
	if Input.is_action_pressed("quit"):
		quit()


# Events #


func _on_source_browse() -> void:
	print("source open")
	_on_browse(FileDialog.FILE_MODE_OPEN_FILE,
			_on_source_changed)


func _on_source_changed(path: String) -> void:
	print("source changed to ", path)
	var seg := get_dir_name_ext(path)
	var dir := seg[0]
	var fna := seg[1]
	# var ext := seg[2]

	%SourceTxt.text = path
	%WavPathTxt.text = dir + SLASH + fna + DOT + WAV
	%DirPathTxt.text = dir + SLASH
	print(get_dir_name_ext(path))

func _on_keepwav_toggle(state: bool) -> void:
	print("keep wav ", state)


func _on_wav_browse() -> void:
	print("wav browse")
	_on_browse(FileDialog.FILE_MODE_OPEN_FILE,
			_on_wav_changed)


func _on_wav_changed(path: String) -> void:
	print("wav changed to ", path)
	%WavPathTxt.txt = path


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
	print(tr("abort"))


func quit() -> void:
	print("quit")
	get_tree().quit()
