extends CanvasLayer

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS

func _on_start_button_pressed():
  Globals.start_game()
