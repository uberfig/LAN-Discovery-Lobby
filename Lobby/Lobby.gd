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
		$Connect/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Connect/Name.text = desktop_path[desktop_path.size() - 2]


func _on_host_pressed():
	if $Connect/Name.text == "": #makes sure the player has a real name
		$Connect/ErrorLabel.text = "Invalid name!"
		return

	$Connect.hide()
	$Players.show()
	$Connect/ErrorLabel.text = ""

	var player_name = $Connect/Name.text
	gamestate.host_game(player_name)
	refresh_lobby()


func _on_join_pressed():
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return

	var ip = $Connect/IPAddress.text
	if not ip.is_valid_ip_address():
		$Connect/ErrorLabel.text = "Invalid IP address!"
		return

	$Connect/ErrorLabel.text = ""
	$Connect/Host.disabled = true
	$Connect/Join.disabled = true

	var player_name = $Connect/Name.text
	gamestate.join_game(ip, player_name)


func _on_connection_success():
	$Connect.hide()
	$Players.show()


func _on_connection_failed():
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false
	$Connect/ErrorLabel.set_text("Connection failed.")


func _on_game_ended():
	show()
	$Connect.show()
	$Players.hide()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false


func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()
	$Connect/Host.disabled = false
	$Connect/Join.disabled = false


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





func _on_HostMode_pressed():
	pass # Replace with function body.


func _on_JoinMode_pressed():
	pass # Replace with function body.



#below for server browser

export (NodePath) var serverListPath: NodePath
onready var serverList := get_node(serverListPath)

func _on_ServerListener_new_server(serverInfo):
	# Create some UI for the newly found server
	var serverNode := Label.new()
	serverNode.text = "%s - %s" % [serverInfo.ip, serverInfo.name]
	serverList.add_child(serverNode)

func _on_ServerListener_remove_server(serverIp):
	for serverNode in serverList.get_children():
		# Just a hacky way to identify the Node and remove it
		if serverNode.text.find(serverIp) > -1:
			serverList.remove_child(serverNode)
			break


#below for hosting server

export (NodePath) var advertiserPath: NodePath
onready var advertiser := get_node(advertiserPath)

const PORT := 3333


func _enter_tree():
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(PORT)
	if result == OK:
		get_tree().set_network_peer(peer)
		print("Game hosted")
	else:
		print("Failed to host game")


#func _ready():
#	# Set this lobby's info to be advertised
#	advertiser.serverInfo["name"] = "A great lobby"
#	advertiser.serverInfo["port"] = PORT

