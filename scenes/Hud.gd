extends CanvasLayer

@onready var health_bar = %HealthBar
@onready var health_bar_label = %HealthBarLabel
@onready var coin_count = %CoinCount


func _ready():
	Globals.connect("player_coins_gained", _on_player_coins_gained)
	Globals.connect("player_damaged", _on_player_damaged)


func _on_player_coins_gained(_amount: int):
	update_coin_count()


func _on_player_damaged(_damage: int):
	update_health_bar()


func update_health_bar():
	health_bar.max_value = float(Globals.player_max_health)
	health_bar.value = float(Globals.player_health)
	health_bar_label.text = str(Globals.player_health) + "/" + str(Globals.player_max_health)


func update_coin_count():
	coin_count.text = str(Globals.player_coins)
