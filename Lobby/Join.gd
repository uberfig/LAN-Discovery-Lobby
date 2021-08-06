extends Panel


#below for server browser


onready var serverList = $ServerList

signal Join_pressed()

var open_servers = {}

func _ready():
	$Name.text = gamestate.system_name

func _on_ServerListener_new_server(serverInfo):
	# Create some UI for the newly found server
	print(serverInfo.name)
	serverList.add_item(str(serverInfo.name, " -- ", serverInfo.ip))
	open_servers[serverInfo.ip] = serverInfo.name

func _on_ServerListener_remove_server(serverIp):
	serverList.clear()
	reset_server_list()


func reset_server_list():
	
	for ip in open_servers:
		serverList.add_item(str(open_servers[ip], " -- ", ip), null, true)


func _on_ServerList_item_selected(index):
	print(index)

func _on_Join_pressed():
	emit_signal("Join_pressed")
