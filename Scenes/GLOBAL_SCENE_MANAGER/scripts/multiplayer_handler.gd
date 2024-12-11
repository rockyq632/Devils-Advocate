class_name MultiplayerHandler
extends Node

var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var ip:String = "127.0.0.1"
var port:int = 2069

var peer_ids:Array[int] = []

func _ready() -> void:
	# This node does nothing until connected to something
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	peer.poll()
	#print( peer.host )
	
	#print( peer.get_available_packet_count() )
	
	#if(peer.get_available_packet_count() > 0):
	#	print( peer.get_available_packet_count() )
	

func _become_server() -> bool:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	return multiplayer.is_server()
	
	
func _become_client() -> bool:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	return (not multiplayer.is_server())
	
func _become_singleplayer() -> void:
	set_process(false)
	

func add_player(id:int, pc_selected:String) -> void:
	if(id in peer_ids):
		return
	
	var new_pc:Control = load(pc_selected).instantiate()
	new_pc.name = str( id )
	
	peer_ids.append(id)
	print( peer_ids )

@rpc("any_peer", "call_local")
func rpc_add_all_players(pc_selected:String) -> void:
	for i in multiplayer.get_peers():
		add_player( i, pc_selected )

func add_all_players(pc_selected:String) -> void:
	rpc("rpc_add_all_players", pc_selected)
