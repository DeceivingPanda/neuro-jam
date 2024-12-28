extends Node2D

var neuro: PackedScene = preload("res://scenes/player/2d_neuro.tscn")
var seagullScene: PackedScene = preload("res://scenes/enemies/seagull.tscn")

#character
var posPlayer:Vector2 
var player:CharacterBody2D 

#enemies
var seagullFlyer:StaticBody2D
var seagullSwimmer:StaticBody2D

var posFlyer:Vector2 
var posSwimmer:Vector2 

var spawnerDelayFlyer: float = 4
var spawnerDelaySwimmer: float = 4

var timeElapsedFlyer: float = 0
var timeElapsedSwimmer: float = 0

#score
var distanceTraveled: float = 0
var score: float = 0
var level: int = 1
var SCORE_MULTIPLAYER: float = floorf((level + exp(level))/2)
const SCORE_WIN: int = 1000

func _ready() -> void:
	player = neuro.instantiate()
	seagullFlyer = seagullScene.instantiate()
	seagullSwimmer = seagullScene.instantiate()
	
	#add scenes to current tree
	$Player.add_child(player)
	$Enemies.add_child(seagullFlyer)
	$Enemies.add_child(seagullSwimmer)
	
	posPlayer = $Floor/Marker2D.global_position
	player.global_position = posPlayer
	
	posFlyer = $Enemies/Flyer.global_position
	seagullFlyer.global_position = posFlyer
	
	posSwimmer = $Enemies/Swimmer.global_position
	seagullSwimmer.global_position = posSwimmer
	
	if seagullFlyer.has_signal("somethingHit"):
		var hit: Signal = seagullFlyer.somethingHit
		hit.connect(_on_enemeny_hit,4)
		
	if seagullSwimmer.has_signal("somethingHit"):
		var hit: Signal = seagullSwimmer.somethingHit
		hit.connect(_on_enemeny_hit,4)
	
	player.set("SPEED", 0.0)
	player.set_physics_process(true)
	seagullFlyer.set_physics_process(true)
	seagullSwimmer.set_physics_process(true)


func _process(_delta: float) -> void:
	#$"Player/2DNeuro".set_physics_process(true)
	#$Enemies/Seagull.set_physics_process(true)
	
	#move timer forward
	timeElapsedFlyer += _delta
	timeElapsedSwimmer += _delta
	distanceTraveled += _delta
	
	if seagullFlyer.global_position.x < -100 && timeElapsedFlyer >= spawnerDelayFlyer:
		seagullFlyer.visible = false
		seagullFlyer.set_physics_process(false)
	
	if seagullSwimmer.global_position.x < -100 && timeElapsedSwimmer >= spawnerDelaySwimmer:
		seagullSwimmer.visible = false
		seagullSwimmer.set_physics_process(false)
	
	#spawn enemies
	if timeElapsedFlyer >= spawnerDelayFlyer:
		print("we can spawn some flyers")
		timeElapsedFlyer=0
		seagullFlyer.global_position = posFlyer
		seagullFlyer.visible = true
		seagullFlyer.set_physics_process(true)
	
	if timeElapsedSwimmer >= spawnerDelaySwimmer:
		print("we can spawn some swimmers")
		timeElapsedSwimmer = 0
		seagullSwimmer.global_position = posSwimmer
		seagullSwimmer.visible = true
		seagullSwimmer.set_physics_process(true)
		
	var addScore: float = SCORE_MULTIPLAYER * _delta
	score += addScore
	#print("distance: %s, addScore: %s, score: %s," % [distanceTraveled, addScore, score])
	
	if score > SCORE_WIN:
		print("player won")
		seagullSwimmer.set_physics_process(false)
		seagullFlyer.set_physics_process(false)
		player.set_physics_process(false)

func _on_enemeny_hit(body: CharacterBody2D):
	print("player hit something: %s" % body)
	if distanceTraveled > 0:
		get_tree().paused = true
