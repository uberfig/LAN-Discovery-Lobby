extends Panel

#
#export (NodePath) var advertiserPath: NodePath
#onready var advertiser := get_node(advertiserPath)
#
#const PORT := gamestate.DEFAULT_PORT

signal Host_pressed()

#func begin_host():
#	advertiser.serverInfo["name"] = $Name.text
#	advertiser.serverInfo["port"] = PORT
#	var peer = NetworkedMultiplayerENet.new()
#	var result = peer.create_server(PORT)
#	if result == OK:
#		get_tree().set_network_peer(peer)
#		print("Game hosted")
#	else:
#		print("Failed to host game")
	






#change this so that the signal is directly relayed to 
#the lobby script and remove everything above as gamestate.gd 
#will handle the server creation

func _on_Host_pressed():
#	begin_host()
	emit_signal("Host_pressed")
