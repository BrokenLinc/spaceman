extends CanvasLayer

@onready var startButton = %StartButton;

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS
  startButton.grab_focus()

func _on_start_button_pressed():
  Globals.start_game()
