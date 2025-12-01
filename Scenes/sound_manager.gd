extends Node

@onready var bgm_player: AudioStreamPlayer
@onready var sfx_player: AudioStreamPlayer

var master_volume: float = 1.0
var bgm_volume: float = 0.5
var sfx_volume: float = 0.8

var current_bgm: String = ""

var sfx_cache: Dictionary = {}
var bgm_cache: Dictionary = {}


func _ready() -> void:
	if not has_node("BGMPlayer"):
		bgm_player = AudioStreamPlayer.new()
		bgm_player.name = "BGMPlayer"
		bgm_player.bus = "BGM"
		add_child(bgm_player)
	
	if not has_node("SFXPlayer"):
		sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer"
		sfx_player.bus = "SFX"
		sfx_player.max_polyphony = 5
		add_child(sfx_player)
	
	bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)
	sfx_player.volume_db = linear_to_db(sfx_volume * master_volume)

## ==================== BGM ====================
func play_bgm(path: String, fade_duration: float = 1.0) -> void:
	if current_bgm == path and bgm_player.playing:
		return
	
	if bgm_player.playing and fade_duration > 0:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", -80, fade_duration)
		tween.tween_callback(func(): _start_new_bgm(path, fade_duration))
	else:
		_start_new_bgm(path, fade_duration)


func _start_new_bgm(path: String, fade_duration: float) -> void:
	var stream = _load_audio(path, bgm_cache)
	if stream:
		bgm_player.stream = stream
		bgm_player.play()
		current_bgm = path
		
		if fade_duration > 0:
			bgm_player.volume_db = -80
			var tween = create_tween()
			tween.tween_property(bgm_player, "volume_db", 
				linear_to_db(bgm_volume * master_volume), fade_duration)
		else:
			bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)


func stop_bgm(fade_duration: float = 1.0) -> void:
	if not bgm_player.playing:
		return
	
	if fade_duration > 0:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", -80, fade_duration)
		tween.tween_callback(func(): 
			bgm_player.stop()
			current_bgm = ""
		)
	else:
		bgm_player.stop()
		current_bgm = ""


func pause_bgm() -> void:
	bgm_player.stream_paused = true


func resume_bgm() -> void:
	bgm_player.stream_paused = false


## ==================== SFX ====================
func play_sfx(path: String, volume_modifier: float = 1.0) -> void:
	var stream = _load_audio(path, sfx_cache)
	if stream:
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.bus = "SFX"
		player.volume_db = linear_to_db(sfx_volume * master_volume * volume_modifier)
		add_child(player)
		player.play()
		
		player.finished.connect(func(): player.queue_free())


## ==================== Controles de Volume ====================
func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)
	_update_volumes()

func set_bgm_volume(volume: float) -> void:
	bgm_volume = clamp(volume, 0.0, 1.0)
	bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)

func _update_volumes() -> void:
	bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)


## ==================== Utilitários ====================
## Carrega um arquivo de áudio e faz cache
func _load_audio(path: String, cache: Dictionary) -> AudioStream:
	if cache.has(path):
		return cache[path]
	
	if ResourceLoader.exists(path):
		var stream = load(path) as AudioStream
		if stream:
			cache[path] = stream
			return stream
		else:
			push_error("AudioManager: Falha ao carregar áudio: " + path)
	else:
		push_error("AudioManager: Arquivo não encontrado: " + path)
	
	return null


func clear_cache() -> void:
	sfx_cache.clear()
	bgm_cache.clear()

func get_master_volume() -> float:
	return master_volume

func get_bgm_volume() -> float:
	return bgm_volume

func get_sfx_volume() -> float:
	return sfx_volume
