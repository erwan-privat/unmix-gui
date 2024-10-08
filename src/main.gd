extends PanelContainer
class_name Main


const SLASH := "/"
const DOT := "."
const SUBDIR := "unmix"
const WAV := "wav"
const MP3 := "mp3"

const CFG_PATH := "user://config.ini"
const CFG_LANG := "lang"
const CFG_LAST := "last_source"
const CFG_KEEP := "keep_wav"
const CFG_OPEN := "open_dir"

const BUS := "master"

var _thread: Thread
var _pipe: FileAccess
var _perr: FileAccess
var _pid: int = 0


func _ready() -> void:
	get_viewport().files_dropped.connect(_on_files_dropped)
	load_settings()
	reset_ui()


func _process(_delta):
	if Input.is_action_pressed("quit"):
		quit()


func _notification(what):
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			print("close request")
			save_settings()
			if _pipe: _pipe.close()
			get_tree().quit()


# Events #


func _on_files_dropped(paths: PackedStringArray) -> void:
	print("dropped ", paths)
	if paths.size() > 1:
		error("Please only drop one file.")
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
	var ext := seg[2]

	# FIXME hide or not, I know not
	var already_wav =  ext.to_lower() == WAV
	%WavContainer.visible = !already_wav
	%KeepWavBtn.set_pressed_no_signal(already_wav)

	%SourceTxt.text = path
	%WavPathTxt.text = dir + SLASH + fna + DOT + WAV
	%DirPathTxt.text = dir + SLASH

	# FIXME check files/dir exists


func _on_keepwav_toggle(state: bool) -> void:
	print("keep wav ", state)


func _on_wav_browse() -> void:
	print("wav browse")
	_on_browse(FileDialog.FILE_MODE_OPEN_FILE,
			_on_wav_changed)


func _on_wav_changed(path: String) -> void:
	print("wav changed to ", path)
	%WavPathTxt.text = path
	var seg := get_dir_name_ext(path)
	var fna := seg[1]
	%DirLbl.text = fna + SLASH


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
	print("unmix")
	%UnmixBtn.disabled = true
	unmix()


# Main functions #


func save_settings() -> void:
	print("save settings")
	var cf := ConfigFile.new()
	cf.set_value("", CFG_LANG, TranslationServer.get_locale())
	cf.set_value("", CFG_LAST, %SourceTxt.text)
	cf.set_value("", CFG_KEEP, %KeepWavBtn.button_pressed)
	cf.set_value("", CFG_OPEN, %OpenDirBtn.button_pressed)
	cf.save(CFG_PATH)


func load_settings() -> void:
	print("load settings")
	var cf := ConfigFile.new()
	cf.load(CFG_PATH)
	# FIXME create defaults more explicitly

	var lang = cf.get_value("", CFG_LANG)
	if lang == null:
		lang = "en"

	TranslationServer.set_locale(lang)
	var last = cf.get_value("", CFG_LAST)
	var keep = cf.get_value("", CFG_KEEP)
	var open = cf.get_value("", CFG_OPEN)
	%SourceTxt.text = last if last != null else ""
	_on_source_changed(%SourceTxt.text)
	_on_wav_changed(%WavPathTxt.text)

	%KeepWavBtn.button_pressed = \
			keep if keep != null else false
	%OpenDirBtn.button_pressed = \
			open if open != null else false


## Return an array containing the conversion from the string
## "/full/path/filename.ext" to ["/full/path", "filename",
## "ext"]
func get_dir_name_ext(path: String) -> PackedStringArray:
	var segments := path.split(SLASH)
	var dir := SLASH.join(segments.slice(0, -1))
	var fn_seg := segments[-1].split(DOT)
	var fn := DOT.join(fn_seg.slice(0, -1))
	var ext := fn_seg[-1]
	return [dir, fn, ext]


func unmix() -> void:
	var src_path = %SourceTxt.text
	var wav_path = %WavPathTxt.text
	var dir_path = %DirPathTxt.text + %DirLbl.text

	if not (src_path and wav_path and dir_path) \
			or src_path == "" \
			or wav_path == "" \
			or dir_path == "":
		error("Invalid paths to unmix")
		return

	%Console.text = ""

	var params := [src_path, wav_path, dir_path]

	%Progress.indeterminate = true
	_thread = Thread.new()
	_thread.start(shell.bind(params))
	%AbortBtn.disabled = false


func shell(params: Array) -> void:
	print("executing unmix with params ", params)

	var dic := OS.execute_with_pipe("./umx.sh", params)
	_pipe = dic.stdio
	_perr = dic.stderr
	_pid = dic.pid
	print("process id ", _pid)

	while _pipe.is_open() and _pipe.get_error() == OK:
		var c = char(_pipe.get_8())
		if c == "[":
			c = "[lb]"
		elif c == "]":
			c = "[rb]"
		to_console.call_deferred(c)

	to_console.call_deferred("[color=#ff8800]")
	while _perr.is_open() and _perr.get_error() == OK:
		to_console.call_deferred(char(_perr.get_8()))
	to_console.call_deferred("[/color]")

	finish_shell.call_deferred()


func finish_shell() -> void:
	_thread.wait_to_finish()

	if not %KeepWavBtn.button_pressed:
		delete_temp_wav()

	if %OpenDirBtn.button_pressed:
		open_dir()

	clog(tr("Done!"))
	reset_ui()


func delete_temp_wav() -> void:
	var wav = %WavPathTxt.text
	clog("deleting " + wav)
	OS.move_to_trash(wav)


func open_dir() -> void:
	var dir = %DirPathTxt.text + %DirLbl.text
	print("open ", dir)
	OS.shell_open(dir)


func to_console(c: String):
	# do not use append_text, for reparsing BBCode
	%Console.text += c
	# %Console.append_text(c)


func clog(msg: String) -> void:
	print("> ", msg)
	%Console.append_text(msg + "\n")


func error(msg: String) -> void:
	printerr(msg)
	var ed := %ErrorDialog
	# OS.alert(msg)
	ed.title = tr("Error")
	ed.dialog_text = msg
	ed.popup_centered()


func abort() -> void:
	print("abort")
	if _pid != 0:
		var err: Error = OS.kill(_pid)
		if err != OK:
			error("OS kill error " + str(err))
		else:
			clog("killed pid " + str(_pid))
			_pid = 0
			reset_ui()


func reset_ui() -> void:
	%Progress.indeterminate = false
	%UnmixBtn.disabled = false
	%AbortBtn.disabled = true


func quit() -> void:
	print("quit")
	abort()
	get_tree().root.propagate_notification(
			NOTIFICATION_WM_CLOSE_REQUEST)
