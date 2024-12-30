extends Node2D

var harpoon_scene: PackedScene = preload("res://scenes/minigames/hacking/objects/harpoon.tscn")
var projectile_scene: PackedScene = preload("res://scenes/minigames/hacking/objects/projectile_square.tscn")

var neuro_scene: PackedScene = preload("res://scenes/minigames/hacking/enemies/neuro.tscn")
var circle_scene: PackedScene = preload("res://scenes/minigames/hacking/enemies/circle.tscn")
var marker_sprial_scene: PackedScene = preload("res://scenes/minigames/hacking/spawns/sprial.tscn")

signal playerWin
signal playerLose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_narative)
	Dialogic.start("Final - Tutorial")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#create enemies
	var neuro:StaticBody2D = neuro_scene.instantiate()
	
	neuro.position = $Enemies/Markers/Boss.global_position
	neuro.connect("death", _on_enemy_death.bind(neuro.type))
	neuro.connect("curhealth", _on_enemy_50.bind(neuro.type))
	neuro.connect("spawnProjectiles", _spawn_enemy_projectiles.bind(10, "neuro_", "CircleShape2D"))
	$Enemies.add_child(neuro)
	
	var circle1:StaticBody2D = circle_scene.instantiate()
	circle1.position = $Enemies/Markers/Enemy1.global_position
	circle1.connect("death", _on_enemy_death.bind(circle1.type))
	circle1.connect("spawnProjectiles", _spawn_enemy_projectiles.bind(4, "circle1_", "CircleShape2D"))
	circle1.name = "Circle1"
	$Enemies.add_child(circle1)
	
	var circle2:StaticBody2D = circle_scene.instantiate()
	circle2.position = $Enemies/Markers/Enemy2.global_position
	circle2.connect("death", _on_enemy_death.bind(circle2.type))
	circle2.connect("spawnProjectiles", _spawn_enemy_projectiles.bind(4, "circle2_", "CircleShape2D"))
	circle2.name = "Circle2"
	$Enemies.add_child(circle2)
	
	$Player.connect("shootHarpoon", _on_player_shoot_harpon)
	$Player.connect("death", _on_player_death)
	
	neuro.find_child("FireTimer").start(4)
	circle1.find_child("FireTimer").start(2)
	circle2.find_child("FireTimer").start(2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _narative(argument: String):
	if argument == "auto":
		Dialogic.Inputs.auto_advance.enabled_forced = true
	elif argument == "manual":
		Dialogic.Inputs.auto_advance.enabled_forced = false

func _on_player_shoot_harpon(pos: Vector2, player_direction: Vector2) -> void:
	var harpoon:Area2D = harpoon_scene.instantiate()
	#print(pos)
	harpoon.position = pos
	harpoon.rotation = player_direction.angle()
	harpoon.direction = player_direction
	harpoon.scale = Vector2(0.5,0.5)
	harpoon.connect("body_entered", _handle_projectile.bind(harpoon))
	harpoon.connect("area_entered", _handle_projectile.bind(harpoon))
	harpoon.connect("despawn", _on_projectile_despawn)
	$Projectiles.add_child(harpoon)
	harpoon.find_child("despawnTimer").start(2)


func _handle_projectile(body: Node2D, projectile: Area2D):
	#print("46: body: %s type: %s" % [body, body.type])
	match body.type:
		"Enemy_Body":
			_on_projectile_hit_enemy(body, projectile)
		"Enemy_Boss":
			_on_projectile_hit_enemy(body, projectile)
		"Enemy_Projectile":
			_on_projectile_hit_enemy_projectile(body, projectile)
		"Player":
			_on_projectile_hit_player(body, projectile)
		"Player_Projectile":
			_on_projectile_hit_enemy_projectile(body, projectile)
		_:
			push_error("something else got hit: %s, with type: %s" % [body, body.type])

func _on_projectile_hit_enemy(enemy: StaticBody2D, projectile: Node2D) -> void:
	#print("62: projectile: %s, hit enemy: %s" % [projectile,enemy])
	$Projectiles.call_deferred("remove_child", projectile)
	#projectile.disconnect("despawn", _on_projectile_despawn)
	enemy.damage(projectile.damage)
	pass

func _on_projectile_hit_enemy_projectile(enemyProjectile: Node2D, projectile: Node2D) -> void:
	#print("69: player projectile: %s, hit enemy projectile: %s" % [projectile, enemyProjectile])
	$Projectiles.call_deferred("remove_child", projectile)
	#projectile.disconnect("despawn", _on_projectile_despawn)
	$EnemyProjectiles.call_deferred("remove_child", enemyProjectile)
	#enemyProjectile.disconnect("despawn", _on_enemny_projectile_despawn)
	pass

func _on_projectile_hit_player(player: CharacterBody2D, enemyProjectile: Node2D) -> void:
	#print("75: player: %s, was hit by projectile: %s" % [player, enemyProjectile])
	#remove projectile
	$EnemyProjectiles.call_deferred("remove_child", enemyProjectile)
	#enemyProjectile.disconnect("despawn", _on_enemny_projectile_despawn)
	#damage player
	player.damage(enemyProjectile.damage)
	pass

func _on_enemy_death(body: Node2D, type: String) -> void:
	#print("enemy died: %s" % [body.name])
	$Enemies.remove_child(body)
	if type == "Enemy_Boss":
		playerWin.emit()
		
func _on_enemy_50(body: Node2D, type: String) -> void:
	Dialogic.start("Final - Fighting")


func _on_projectile_despawn(projectile: Node2D) -> void:
	#print("deapwning projectile: %s" % [projectile])
	$Projectiles.remove_child(projectile)
	
	
func _on_enemny_projectile_despawn(projectile: Node2D) -> void:
	#print("deapwning projectile: %s" % [projectile])
	$EnemyProjectiles.remove_child(projectile)
	
func _on_player_death() -> void:
	playerLose.emit()
	Dialogic.clear()
	get_tree().change_scene_to_file("res://scenes/story/endings/bad_ending.tscn")


func _spawn_enemy_projectiles(body:Node2D, numProj: int, _name:String, _type:String) -> void:
	#get markers
	var markers:Node2D = marker_sprial_scene.instantiate()
	body.add_child(markers)
	#get_tree().paused=true
	if markers.has_method("_sprial") and body.has_node("CollisionShape2D"):
		var size: int
		match _type:
			"RectShape2D":
				size = body.find_child("CollisionShape2D").shape.size.x
			"CircleShape2D":
				size = body.find_child("CollisionShape2D").shape.radius + 10
		#print(size)
		markers._sprial(numProj, size, _name)
		for marker in markers.find_child("Spawns",false).get_children():
			#print("marker %s" % [marker])
			var emProjectile: Node2D = projectile_scene.instantiate()
			emProjectile.global_position = marker.global_position
			var player_direction: Vector2 = ($Player.global_position - emProjectile.global_position).normalized()
			#print(type_string(typeof(player_direction)))
			#print("$Player.global_position: %s, emProjectile.global_position: %s" % [$Player.global_position, emProjectile.global_position])
			#print("player_direction: %s" % [player_direction])
			emProjectile.connect("body_entered", _handle_projectile.bind(emProjectile))
			emProjectile.connect("despawn", _on_enemny_projectile_despawn)
			emProjectile.direction = player_direction
			emProjectile.visible = true
			$EnemyProjectiles.add_child(emProjectile)
			emProjectile.find_child("despawnTimer").start(5)
	pass
