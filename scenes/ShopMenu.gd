extends CanvasLayer

@onready var buyButtons = %BuyButtons
@onready var buyButton1 = %BuyButton1
@onready var coinCount = %CoinCount

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS
  Globals.connect("player_saved_coins_changed", _on_player_saved_coins_changed)

  update_coin_count()
  buyButton1.grab_focus()


func _on_buy_button_1_pressed():
  Globals.buy_shop_item(1)

func update_coin_count():
  coinCount.text = str(Globals.player_saved_coins)

func _on_player_saved_coins_changed(_amount: int):
  update_coin_count()

func _on_exit_button_pressed():
  print("exit button pressed")
  Globals.load_main_menu()