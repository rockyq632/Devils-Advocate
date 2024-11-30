class_name MultiplayerHandler
extends Node

var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var ip:String = "127.0.0.1"
var port:int = 269


'''
# Create client.
var peer = ENetMultiplayerPeer.new()
peer.create_client(IP_ADDRESS, PORT)
multiplayer.multiplayer_peer = peer

# Create server.
var peer = ENetMultiplayerPeer.new()
peer.create_server(PORT, MAX_CLIENTS)
multiplayer.multiplayer_peer = peer
'''

func _ready() -> void:
	# This node does nothing until connected to something
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# If no peer exists, get out of process
	if( not peer  or  not multiplayer):
		set_process(false)
		
	peer.poll()
	# If current instance is a server
	if( multiplayer.is_server() ):
		update_clients()
	# If current instance is a client
	else:
		update_server()





###								###
###		Server Functions		###
###								###

# Becomes a server
func _become_server() -> bool:
	#get_local_ip()
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	return multiplayer.is_server()


# Erases Network presence and returns to singleplayer mode
func _become_singleplayer() -> void:
	peer = ENetMultiplayerPeer.new()
	set_process(false)


# Get IP Address
func get_local_ip() -> String:
	var ip_adr:String = ""
	var temp:Array[String] = []
	for i in IP.get_local_addresses():
		if( i.begins_with("127")):
			continue
		elif( "." in i ):
			temp.append(i)
	
	print(temp)
	'''
	# If on Windows
	if( OS.has_feature("windows")  and  OS.has_feature("COMPUTERNAME")):
		ip_adr = IP.resolve_hostname( str(OS.get_environment("COMPUTERNAME")), IP.TYPE_IPV4 )
	# If on Linux or Mac
	elif( (OS.has_feature("x11") or OS.has_feature("OSX"))  and  OS.has_feature("HOSTNAME") ):
		ip_adr = IP.resolve_hostname( str(OS.get_environment("HOSTNAME")), IP.TYPE_IPV4 )
	'''
	return ip_adr


# Updates a specific client  if current instance is a server
func update_client(id:int) -> void:
	if( not multiplayer.is_server()):
		return
	var spec_client:ENetPacketPeer = peer.get_peer(id)
	print( spec_client.get_channels() )


# Updates all clients if current instance is a server
func update_clients() -> void:
	if( not multiplayer.is_server()):
		return
	for id:int in multiplayer.get_peers():
		update_client(id)


# Kicks a specific client if current instance is a server
func kick_client(id:int) -> void:
	if( not multiplayer.is_server()):
		return
	var spec_client:ENetPacketPeer = peer.get_peer(id)
	spec_client.peer_disconnect()



###								###
###		Client functions		###
###								###

# Joins a server
func _become_client() -> bool:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	return (not multiplayer.is_server())


# Updates the server if current instance is a client
func update_server() -> void:
	if(multiplayer.is_server()):
		return
	pass #TODO
