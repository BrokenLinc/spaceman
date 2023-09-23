extends CanvasLayer

@onready var health_bar = %HealthBar
@onready var health_bar_label = %HealthBarLabel
@onready var coin_count = %CoinCount


func update_health_bar():
	health_bar.max_value = float(Globals.player_max_health)
	health_bar.value = float(Globals.player_health)
	health_bar_label.text = str(Globals.player_health) + "/" + str(Globals.player_max_health)


func update_coins():
	coin_count.text = str(Globals.player_coins)
