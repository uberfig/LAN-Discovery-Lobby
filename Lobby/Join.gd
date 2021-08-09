extends Panel


#below for server browser


onready var server_list = $ServerList
onready var enter_ip = $IPAddress




func _on_ServerListener_new_server(serverInfo):
	server_list.add_item(str(serverInfo.name, " -- ", serverInfo.ip))
	var fooIndex = server_list.get_item_count() - 1
	server_list.set_item_metadata(fooIndex, serverInfo.ip)


func _on_ServerListener_remove_server(serverIp):
	for index in server_list.get_item_count():
		if server_list.get_item_metadata(index) == serverIp:
			server_list.remove_item(index)




func _on_ServerList_item_selected(index):
	enter_ip.text = str(server_list.get_item_metadata(index))
	
