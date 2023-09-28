extends CanvasLayer

@onready var mainMenuButton = %MainMenuButton;

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS
  %Root.hide()

  Globals.connect("player_died", _on_player_died)

func _on_main_menu_button_pressed():
  Globals.load_main_menu()

func _on_player_died():
  %Root.show()
  mainMenuButton.grab_focus()