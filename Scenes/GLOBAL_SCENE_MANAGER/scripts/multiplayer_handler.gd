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
	peer.poll()
	

func _become_server() -> bool:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	return multiplayer.is_server()
	
	
func _become_client() -> bool:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	return (not multiplayer.is_server())
