extends Node2D

var neuro: PackedScene = preload("res://scenes/player/2d_neuro.tscn")
var seagullScene: PackedScene = preload("res://scenes/enemies/seagull.tscn")

#character
var posPlayer:Vector2 
var player:CharacterBody2D 

#enemies
var seagullFlyer:StaticBody2D
var seagullSwimmer:StaticBody2D

var seagullFlyerSprites:Array[Node]
var seagullSwimmerSprites:Array[Node]

var seagullFlyerSpritesCurr: int = 0
var seagullSwimmerSpritesCurr: int = 0

var posFlyer:Vector2 
var posSwimmer:Vector2 

#variables for spawning and randomness
var spawnerDelayFlyer: float = 15.0
const spawnerDelayFlyerMAX: float = 20.0
const spawnerDelayFlyerMIN: float = 5.0
const spawnerDelayFlyerMAXChange: float = -3.0
const spawnerDelayFlyerMINChange: float = 2

var spawnerDelaySwimmer: float = 4.0
const spawnerDelaySwimmerMAX: float = 10.0
const spawnerDelaySwimmerMIN: float = 4.0
const spawnerDelaySwimmerMAXChange: float = -2.0
const spawnerDelaySwimmerMINChange: float = 4

var timeElapsedFlyer: float = 0
var timeElapsedSwimmer: float = 0

#score
var distanceTraveled: float = 0
var score: float = 0
var level: int = 1
var SCORE_MULTIPLAYER: float = floorf((level + exp(level))/2)
const SCORE_WIN: int = 50

func _ready() -> void:
	player = neuro.instantiate()
	seagullFlyer = seagullScene.instantiate()
	seagullSwimmer = seagullScene.instantiate()
	
	#add scenes to current tree
	$Player.add_child(player)
	$Enemies.add_child(seagullFlyer)
	$Enemies.add_child(seagullSwimmer)
	
	posPlayer = $Player/Marker2D.global_position
	player.global_position = posPlayer
	
	#used to change the physics for the scene
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.UP)
	#change player movement to be inverted
	player.up_direction = Vector2.DOWN
	player.JUMP_VELOCITY = -player.JUMP_VELOCITY
	
	#move and apply scale on enemies
	posFlyer = $Enemies/Flyer.global_position
	seagullFlyer.apply_scale(Vector2(3,3))
	seagullFlyer.global_position = Vector2(-200, posFlyer.y)
	
	posSwimmer = $Enemies/Swimmer.global_position
	seagullSwimmer.apply_scale(Vector2(3,3))
	seagullSwimmer.global_position = Vector2(-200, posSwimmer.y)
	
	#set normal sprite
	seagullFlyerSprites = seagullFlyer.get_node("Sprites").get_children(false)
	seagullFlyerSprites[seagullFlyerSpritesCurr].visible = true
	
	seagullSwimmerSprites = seagullSwimmer.get_node("Sprites").get_children(false)
	seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = true
	
	if seagullFlyer.has_signal("hitSomething"):
		seagullFlyer.hitSomething.connect(_on_enemeny_hit,2)
		
	if seagullSwimmer.has_signal("hitSomething"):
		seagullSwimmer.hitSomething.connect(_on_enemeny_hit,2)
	
	player.set("SPEED", 0.0)
	player.set_physics_process(true)
	seagullFlyer.set_physics_process(true)
	seagullSwimmer.set_physics_process(true)
	
	randomize()


func _process(_delta: float) -> void:
	#$"Player/2DNeuro".set_physics_process(true)
	#$Enemies/Seagull.set_physics_process(true)
	get_tree().root.content_scale_size
	#move timer forward
	timeElapsedFlyer += _delta
	timeElapsedSwimmer += _delta
	distanceTraveled += _delta
	
	if seagullFlyer.global_position.x < -200 && timeElapsedFlyer <= spawnerDelayFlyer:
		seagullFlyer.visible = false
		seagullFlyer.set_physics_process(false)
	
	if seagullSwimmer.global_position.x < -200 && timeElapsedSwimmer <= spawnerDelaySwimmer:
		seagullSwimmer.visible = false
		seagullSwimmer.set_physics_process(false)
	
	#spawn enemies
	if timeElapsedFlyer >= spawnerDelayFlyer && seagullFlyer.global_position.x < -200:
		print("we can spawn some flyers")
		timeElapsedFlyer=0
		
		#change to random sprite type
		seagullFlyerSprites[seagullFlyerSpritesCurr].visible = false
		print("changing flyer sprite to %s" % seagullFlyerSprites[seagullFlyerSpritesCurr].name)
		seagullFlyerSpritesCurr = randi_range(0,seagullFlyerSprites.size()-1)
		seagullFlyerSprites[seagullFlyerSpritesCurr].visible = true
		
		seagullFlyer.global_position = posFlyer
		seagullFlyer.visible = true
		seagullFlyer.set_physics_process(true)
		
		#randomize spaqn
		spawnerDelayFlyer = deltaT(spawnerDelayFlyer, spawnerDelayFlyerMIN, spawnerDelayFlyerMAX, spawnerDelayFlyerMINChange, spawnerDelayFlyerMAXChange)
		print(spawnerDelayFlyer)
	
	if timeElapsedSwimmer >= spawnerDelaySwimmer && seagullSwimmer.global_position.x < -200:
		print("we can spawn some swimmers")
		timeElapsedSwimmer = 0
		
		#change to random sprite type
		seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = false
		print("changing Swimmer sprite to %s" % seagullSwimmerSprites[seagullSwimmerSpritesCurr].name)
		seagullSwimmerSpritesCurr = randi_range(0,seagullSwimmerSprites.size()-1)
		seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = true
		
		seagullSwimmer.global_position = posSwimmer
		seagullSwimmer.visible = true
		seagullSwimmer.set_physics_process(true)
		
		#randomize spaqn
		spawnerDelaySwimmer = deltaT(spawnerDelaySwimmer, spawnerDelaySwimmerMIN, spawnerDelaySwimmerMAX, spawnerDelaySwimmerMINChange, spawnerDelaySwimmerMAXChange)
		print(spawnerDelaySwimmer)
		
	var addScore: float = SCORE_MULTIPLAYER * _delta
	score += addScore
	#print("distance: %s, addScore: %s, score: %s," % [distanceTraveled, addScore, score])
	
	$Control/Score.text = "Score: %s " % floor(score)
	if score > SCORE_WIN: _on_win()


func _on_enemeny_hit(body: CharacterBody2D):
	print("player hit something: %s, distance: %s, score: %s" % [body, distanceTraveled, score])
	get_tree().paused = true


func deltaT(value: float,  minF: float, maxF: float, minChange: float, maxChange: float) -> float:
	var change: float = randf_range(minChange,maxChange)
	return clamp(value+change, minF, maxF)


func _on_win() -> void:
	print("player won: Scored %s points" % [score])
	get_tree().paused = true
