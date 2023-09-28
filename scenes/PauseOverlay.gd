extends CanvasLayer

@onready var resumeButton = %ResumeButton;

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS
  %Root.hide()

  Globals.connect("game_paused", _on_game_paused)
  Globals.connect("game_resumed", _on_game_resumed)


func _on_game_paused():
  %Root.show()
  resumeButton.grab_focus()


func _on_game_resumed():
  %Root.hide()


func _on_main_menu_button_pressed():
  Globals.load_main_menu()


func _on_resume_button_pressed():
  Globals.set_paused(false)
