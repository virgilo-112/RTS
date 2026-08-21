extends Node



func _on_host_game_pressed() -> void:
	NetworkManager.host_game()
	
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_join_game_pressed() -> void:
	NetworkManager.join_game("127.0.0.1")
	
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_option_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
