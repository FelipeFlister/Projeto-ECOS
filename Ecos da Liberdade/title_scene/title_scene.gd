extends Node2D

const START_LEVEL : String = "res://Levels/Ecos/01_casa_do_personagem.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/ButtonNew
@onready var button_continue: Button = $CanvasLayer/Control/ButtonContinue
@onready var button_exit: Button = $CanvasLayer/Control/ButtonExit
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var text_screen: Control = $CanvasLayer/TextScreen

var game_started: bool = false

func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	PlayerHud.visible = false
	text_screen.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		button_continue.disabled = true
		button_continue.visible = false
		button_exit.position = Vector2(174, 174)
	
	$CanvasLayer/SplashScene.finished.connect( setup_title_screen )
	
	LevelManager.level_load_started.connect( exit_title_screen )
	
	# Conectar sinal para quando a tela de texto terminar
	if text_screen.has_signal("finished"):
		text_screen.finished.connect(_on_text_screen_finished)
	
	pass

func _on_text_screen_finished() -> void:
	if game_started:
		# Despausar o jogo quando a tela de texto terminar
		get_tree().paused = false
		game_started = false

func setup_title_screen() -> void:
	AudioManager.play_music( music )
	button_new.pressed.connect( start_game )
	button_continue.pressed.connect( load_game )
	button_exit.pressed.connect(exit_game)
	button_new.grab_focus()
	
	print("Botões conectados - New: ", button_new.pressed.is_connected(start_game))
	print("Botões conectados - Continue: ", button_continue.pressed.is_connected(load_game))
	print("Botões conectados - Exit: ", button_exit.pressed.is_connected(exit_game))
	
	button_new.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continue.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_exit.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass

func start_game() -> void:
	game_started = true
	text_screen.visible = true
	play_audio( button_press_audio )
	
	# Garantir que o jogo continue pausado durante a tela de texto
	get_tree().paused = true
	
	# Iniciar a tela de texto
	if text_screen.has_method("start"):
		text_screen.start()
	
	# Carregar o nível após um pequeno delay para garantir que a tela de texto seja exibida
	await get_tree().create_timer(0.1).timeout
	LevelManager.load_new_level( START_LEVEL, "", Vector2.ZERO )
	pass

func load_game() -> void:
	play_audio( button_press_audio )
	SaveManager.load_game()
	pass

func exit_game() -> void:
	get_tree().quit()

func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass

func play_audio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
