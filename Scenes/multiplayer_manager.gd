extends Node

@export var maxClients : int = 4
@export var address : LineEdit
@export var port : LineEdit
@export var userName : LineEdit
@export var camera : Camera2D

var localUserName : String

var playerScene : PackedScene = preload("res://Characters/Guards/GuardTemplate/guard.tscn")
@onready var spawnedNodes = $SpawnedNodes

func _ready():
	if "--server"in OS.get_cmdline_args():
		var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
		peer.create_server(int(port.text), maxClients)
		multiplayer.multiplayer_peer = peer
		
		multiplayer.peer_connected.connect(_on_player_connected)
		multiplayer.peer_disconnected.connect(_on_player_disconnected)
		
		_on_player_connected(multiplayer.get_unique_id())

func _on_username_text_changed(new_text: String) -> void:
	localUserName = new_text

func startHost():
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(int(port.text), maxClients)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	
	camera.enabled = false
	$"Network UI".visible = false

func startClient():
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(address.text, int(port.text))
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)

func _on_player_connected(id : int):
	print("Player %s joined the game" % id)
	
	var player : Node = playerScene.instantiate()
	spawnedNodes.add_child(player, true)

func _on_player_disconnected(id : int):
	print("Player %s left the game" % id)

func _connected_to_server():
	print("Connected to Server")
	camera.enabled = false
	$"Network UI".visible = false

func _connection_failed():
	print("Connection Failed")

func _server_disconnected():
	print("Server Disconnected")
	camera.enabled = true
	$"Network UI".visible = true
