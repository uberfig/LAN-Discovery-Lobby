extends Control

func _ready():
	# Called every time the node is added to the scene.
# warning-ignore:return_value_discarded
	gamestate.connect("connection_failed", self, "_on_connection_failed")
# warning-ignore:return_value_discarded
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
# warning-ignore:return_value_discarded
	gamestate.connect("player_list_changed", self, "refresh_lobby")
# warning-ignore:return_value_discarded
	gamestate.connect("game_ended", self, "_on_game_ended")
# warning-ignore:return_value_discarded
	gamestate.connect("game_error", self, "_on_game_error")
	# Set the player name according to the system username. Fallback to the path.
	if OS.has_environment("USERNAME"):
		gamestate.system_name = OS.get_environment("USERNAME")
		
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		gamestate.system_name = desktop_path[desktop_path.size() - 2]






func _on_HostMode_pressed():
#	if self.has_node("Host"):
#		$Host.queue_free()
#	if self.has_node("Join"):
#		$Join.queue_free()
	
	$ConnectMethood.hide()
#	var hostmenu = load("res://Lobby/Host.tscn")
#	var instance = hostmenu.instance()
#	add_child(instance)
#	$Host.connect("Host_pressed", self, "_on_host_pressed")
	$Host/Name.text = gamestate.system_name
	$Host.show()


func _on_JoinMode_pressed():
#	if self.has_node("Host"):
#		$Host.queue_free()
#	if self.has_node("Join"):
#		$Join.queue_free()
	
	$ConnectMethood.hide()
#	var joinmenu = load("res://Lobby/Join.tscn")
#	var instance = joinmenu.instance()
#	add_child(instance)
	var server_listener = load("res://Lobby/ServerListener.tscn")
	var instance = server_listener.instance()
	$Join.add_child(instance)
	$Join/ServerListener.connect("new_server", $Join, "_on_ServerListener_new_server")
	$Join/ServerListener.connect("remove_server", $Join, "_on_ServerListener_remove_server")
	
	$Join/Name.text = gamestate.system_name
	$Join.show()



func _on_host_pressed():
	if $Host/Name.text == "": #makes sure the player has a real name
		$Host/ErrorLabel.text = "Invalid name!"
		return

	$Host.hide()
	$Players.show()
	$Host/ErrorLabel.text = ""

	var player_name = $Host/Name.text
	gamestate.host_game(player_name)
	refresh_lobby()


func _on_join_pressed():
	if $Join.has_node("ServerListener"):
		$Join/ServerListener.queue_free()
	
	if $Join/Name.text == "":
		$Join/ErrorLabel.text = "Invalid name!"
		return

	var ip = $Join/IPAddress.text
	if not ip.is_valid_ip_address():
		$Join/ErrorLabel.text = "Invalid IP address!"
		return

	$Join/ErrorLabel.text = ""
	$Join/Join.disabled = true

	var player_name = $Join/Name.text
	gamestate.join_game(ip, player_name)


func _on_connection_success():
	$Join.hide()
	$Players.show()


func _on_connection_failed():
	$Join/Join.disabled = false
	$Host/Host.disabled = false
	$Join/ErrorLabel.set_text("Connection failed.")


func _on_game_ended():
	show()
	$ConnectMethood.show()
	$Players.hide()
	$Host/Host.disabled = false
	$Join/Join.disabled = false


func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Host/Host.disabled = false
	$Join/Join.disabled = false


func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	$Players/List.clear()
	$Players/List.add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		$Players/List.add_item(p)

	$Players/Start.disabled = not get_tree().is_network_server()


func _on_start_pressed():
	gamestate.begin_game()


func _on_find_public_ip_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://icanhazip.com/")


#TODO bring host and join back into the scene once everything is working properly










