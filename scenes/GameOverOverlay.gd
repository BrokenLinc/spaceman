extends CanvasLayer

@onready var mainMenuButton = %MainMenuButton;
@onready var shopMenuButton = %ShopMenuButton;
@onready var coin_count = %CoinCount
@onready var total_coin_count = %TotalCoinCount

func _ready():
  process_mode = Node.PROCESS_MODE_ALWAYS
  %Root.hide()

  Globals.connect("player_died", _on_player_died)

func _on_player_died():
  %Root.show()
  coin_count.text = str(Globals.player_coins)
  total_coin_count.text = str(Globals.player_saved_coins)
  shopMenuButton.grab_focus()

func _on_main_menu_button_pressed():
  Globals.load_main_menu()

func _on_shop_menu_button_pressed():
  Globals.load_shop()
