class_name MPHandler
extends Node


var upnp:UPNP

# peer representing this game instance
var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()

# ip address and port to connect to
var ip:String = "127.0.0.1"
var port:int = 2069

# List of all connected peers
var peer_ids:Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This node does nothing until connected to something
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	multiplayer.multiplayer_peer.poll()

###
###		Host Functions
###
func become_server() -> bool:
	# UPNP -> Universal Plug-N-Play
	'''# TODO Get this game working over the internet
	upnp = UPNP.new()
	var discover_result:int = upnp.discover()
	
	if(discover_result == UPNP.UPNP_RESULT_SUCCESS):
		if( upnp.get_gateway()  and  upnp.get_gateway().is_valid_gateway() ):
			var map_result:int = upnp.add_port_mapping(port, port, "Devils_Advocate_TCP", "TCP", 0)
			upnp.add_port_mapping(port, port, "Devils_Advocate_UDP", "UDP", 0)
			if( not map_result == UPNP.UPNP_RESULT_SUCCESS ):
				upnp.add_port_mapping(port, port, "", "TCP", 0)
				upnp.add_port_mapping(port, port, "", "UDP", 0)
	
	
	var external_ip:String = upnp.query_external_address()
	print( external_ip )
	'''
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	return multiplayer.is_server()


func delete_prt_mapping() -> void:
	if(upnp):
		upnp.delete_port_mapping(port, "UDP")
		upnp.delete_port_mapping(port, "TCP")


###
###		Client functions
###
func become_client() -> bool:
	multiplayer.connected_to_server.connect(_client_connected)
	multiplayer.connection_failed.connect(_client_connection_failed)
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	set_process(true)
	return (not multiplayer.is_server())

# Called when client connects to the server
func _client_connected() -> void:
	pass #TODO

# Called when client fails to connect or is disconnected from the server
func _client_connection_failed() -> void:
	pass #TODO



###
###		Client/Host Functions
###
func _become_singleplayer() -> void:
	set_process(false)
	
	# Reset to player 1
	GSM.ASSIGNED_PLAYER_ORDER_NUM = 1


@rpc("any_peer")
func add_pc(peer_id:int, pc_scene_path:String) -> void:
	if( peer_id in GSM.GLOBAL_MULTIPLAYER_HANDLER.peer_ids ):
		return
	
	GSM.GLOBAL_MULTIPLAYER_HANDLER.peer_ids.append(peer_id)
	
	var temp:PlayableCharacter = load(pc_scene_path).instantiate()
	temp.name = str( peer_id )
	temp.global_position.x = randi_range(200,500)
	temp.global_position.y = randi_range(200,500)
	temp.set_multiplayer_authority(peer_id)
	GSM.GLOBAL_PLAYER_NODE.add_child( temp )
	
	# Assign player numbers from the host
	if( multiplayer.is_server() ):
		rpc_id(peer_id, "assign_player_number", (GSM.GLOBAL_MULTIPLAYER_HANDLER.peer_ids.size()+1))

func add_pc_to_all_peers(pc_scene_path:String) -> void:
	rpc("add_pc", multiplayer.get_unique_id(), pc_scene_path)

@rpc()
func assign_player_number(pnum:int) -> void:
	GSM.ASSIGNED_PLAYER_ORDER_NUM = pnum
