extends CanvasLayer

func _ready():
  %Root.hide()

  Globals.connect("game_paused", _on_game_paused)
  Globals.connect("game_resumed", _on_game_resumed)


func _on_game_paused():
  %Root.show()


func _on_game_resumed():
  %Root.hide()

