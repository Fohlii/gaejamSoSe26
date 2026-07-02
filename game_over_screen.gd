extends Control
@onready var exit: ConfirmationDialog = $exit
@onready var GameManager = get_tree().current_scene

func _on_restart_pressed() -> void:
	GameManager.start_game()


func _on_back_to_menu_pressed() -> void:
	GameManager.show_menu()
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	exit.popup_centered(Vector2i(300, 150))
	
func _on_exit_confirmed() -> void:
	get_tree().quit()

func _on_exit_canceled() -> void:
	exit.hide()
