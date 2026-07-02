extends Control
@onready var exit: ConfirmationDialog = $exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	GameManager.start_game()


func _on_back_to_menu_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	exit.popup_centered(Vector2i(300, 150))
	
func _on_exit_confirmed() -> void:
	get_tree().quit()


func _on_exit_canceled() -> void:
	exit.hide()
