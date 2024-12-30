extends Node2D

var neuro: PackedScene = preload("res://scenes/player/2d_neuro.tscn")
var seagullScene: PackedScene = preload("res://scenes/minigames/seagull/enemies/seagull.tscn")

#player
var player:CharacterBody2D 

#enemies
var seagullSwimmer:StaticBody2D

var seagullSwimmerSprites:Array[Node]
var seagullSwimmerSpritesCurr: int = 0

var posSwimmer:Vector2 

var changeSprite: Array[bool] = [true, true]

var spawnerDelaySwimmer: float = 4.0
#const spawnerDelaySwimmerMAX: float = 10.0
#const spawnerDelaySwimmerMIN: float = 4.0
#const spawnerDelaySwimmerMAXChange: float = -2.0
#const spawnerDelaySwimmerMINChange: float = 4

var timeElapsedSwimmer: float = 0

#score
var distanceTraveled: float = 0
var level1: int = 10
var level2: int = 30

var max_time: float = 40.0


func _ready() -> void:
	player = neuro.instantiate()
	seagullSwimmer = seagullScene.instantiate()
	
	#add scenes to current tree
	$Player.add_child(player)
	$Enemies.add_child(seagullSwimmer)
	
	player.global_position = $Player/Marker2D.global_position
	
	#used to change the physics for the scene
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.UP)
	#change player movement to be inverted
	player.up_direction = Vector2.DOWN
	player.JUMP_VELOCITY = -player.JUMP_VELOCITY
	
	#move and apply scale on enemies
	posSwimmer = $Enemies/Swimmer.global_position
	seagullSwimmer.apply_scale(Vector2(3,3))
	seagullSwimmer.global_position = Vector2(-1000, posSwimmer.y)
	
	seagullSwimmerSprites = seagullSwimmer.get_node("Sprites").get_children(false)
	seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = true
	
	
	if seagullSwimmer.has_signal("hitSomething"):
		seagullSwimmer.hitSomething.connect(_on_enemeny_hit,2)
	
	player.set("SPEED", 0.0)
	player.set_physics_process(true)
	seagullSwimmer.set_physics_process(true)
	
	randomize()
	$LevelWin.start(max_time)


func _process(_delta: float) -> void:
	#$"Player/2DNeuro".set_physics_process(true)
	#$Enemies/Seagull.set_physics_process(true)
	#get_tree().root.content_scale_size
	#move timer forward
	timeElapsedSwimmer += _delta
	distanceTraveled += _delta
	
	if seagullSwimmer.global_position.x < -1000 && timeElapsedSwimmer <= spawnerDelaySwimmer:
		seagullSwimmer.visible = false
		seagullSwimmer.set_physics_process(false)
	
	#spawn enemies
	if timeElapsedSwimmer >= spawnerDelaySwimmer && seagullSwimmer.global_position.x < -1000:
		#print("we can spawn some swimmers")
		timeElapsedSwimmer = 0
		seagullSwimmer.global_position = posSwimmer
		
		#change sprite
		if distanceTraveled > 10 && changeSprite[0]:
			#print("sprite changed - 10")
			changeSprite[0] = false;
			seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = false
			seagullSwimmerSpritesCurr += 1
			seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = true
			spawnerDelaySwimmer -= 1
			seagullSwimmer.SPEED = 350
		elif distanceTraveled > 35 && changeSprite[1]:
			#print("sprite changed - 35")
			changeSprite[1] = false;
			seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = false
			seagullSwimmerSpritesCurr += 1
			seagullSwimmerSprites[seagullSwimmerSpritesCurr].visible = true
			spawnerDelaySwimmer -= 1
			seagullSwimmer.SPEED = 400
		
		seagullSwimmer.visible = true
		seagullSwimmer.set_physics_process(true)
		
		#randomize spaqn
		#spawnerDelaySwimmer = deltaT(spawnerDelaySwimmer, spawnerDelaySwimmerMIN, spawnerDelaySwimmerMAX, spawnerDelaySwimmerMINChange, spawnerDelaySwimmerMAXChange)
		#print(spawnerDelaySwimmer)


func _on_enemeny_hit(body: CharacterBody2D):
	#print("player hit something: %s, distance: %s" % [body, distanceTraveled])
	get_tree().paused = true
	#TODO: move to bad ending screen
	#get_tree().change_scene_to_file("res://scenes/story/house/house.tscn")


func deltaT(value: float,  minF: float, maxF: float, minChange: float, maxChange: float) -> float:
	var change: float = randf_range(minChange,maxChange)
	return clamp(value+change, minF, maxF)


func _on_level_win_timeout() -> void:
	print("player won: Scored %s points" % [distanceTraveled])
	get_tree().change_scene_to_file("res://scenes/story/house/house.tscn")
