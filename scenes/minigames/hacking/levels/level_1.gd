extends Node2D

var harpoon_scene: PackedScene = preload("res://scenes/minigames/hacking/objects/harpoon.tscn")
var projectile_scene: PackedScene = preload("res://scenes/minigames/hacking/objects/projectile_square.tscn")

var square_scene: PackedScene = preload("res://scenes/minigames/hacking/enemies/square.tscn")
var marker_scene: PackedScene = preload("res://scenes/minigames/hacking/spawns/sprial.tscn")

signal playerWin
signal playerLose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#create enemies
	var square:StaticBody2D = square_scene.instantiate()
	square.position = $Enemies/Markers/Box.global_position
	square.connect("death", _on_enemy_death.bind(square.type))
	$Enemies.add_child(square)
	

	
	$Player.connect("shootHarpoon", _on_player_shoot_harpon)
	$Player.connect("death", _on_player_death)
	$BossFireTimer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_shoot_harpon(pos: Vector2, player_direction: Vector2) -> void:
	var harpoon:Area2D = harpoon_scene.instantiate()
	#print(pos)
	harpoon.position = pos
	harpoon.rotation = player_direction.angle()
	harpoon.direction = player_direction
	harpoon.connect("body_entered", _handle_projectile.bind(harpoon))
	harpoon.connect("despawn", _on_projectile_despawn)
	$Projectiles.add_child(harpoon)
	harpoon.find_child("despawnTimer").start(2)


func _handle_projectile(body: Node2D, projectile: Area2D):
	print("body: %s" % body)
	match body.type:
		"Enemy_Body":
			_on_projectile_hit_enemy(body, projectile)
		"Enemy_Boss":
			_on_projectile_hit_enemy(body, projectile)
		"Enemy_Projectile":
			_on_projectile_hit_enemy_projectile(body, projectile)
		"Player":
			_on_projectile_hit_player(body, projectile)
		_:
			push_error("something else got hit: %s, with type: %s" % [body, body.type])

func _on_projectile_hit_enemy(enemy: StaticBody2D, projectile: Node2D) -> void:
	#print("62: projectile: %s, hit enemy: %s" % [projectile,enemy])
	$Projectiles.call_deferred("remove_child", projectile)
	projectile.disconnect("despawn", _on_projectile_despawn)
	enemy.damage(projectile.damage)
	pass

func _on_projectile_hit_enemy_projectile(enemyProjectile: Node2D, projectile: Node2D) -> void:
	#print("69: player projectile: %s, hit enemy projectile: %s" % [projectile, enemyProjectile])
	$Projectiles.call_deferred("remove_child", projectile)
	projectile.disconnect("despawn", _on_projectile_despawn)
	$EnemyProjectiles.call_deferred("remove_child", enemyProjectile)
	enemyProjectile.disconnect("despawn", _on_enemny_projectile_despawn)
	pass

func _on_projectile_hit_player(player: CharacterBody2D, enemyProjectile: Node2D) -> void:
	#print("75: player: %s, was hit by projectile: %s" % [player, enemyProjectile])
	#remove projectile
	$EnemyProjectiles.call_deferred("remove_child", enemyProjectile)
	enemyProjectile.disconnect("despawn", _on_enemny_projectile_despawn)
	#damage player
	player.damage(enemyProjectile.damage)
	pass

func _on_enemy_death(body: Node2D, type: String) -> void:
	print("enemy died: %s" % [body.name])
	var enemies: Array[Node] = $Enemies.get_children()
	for enemy in enemies:
		#print("enemy : %s" % enemy )
		if body == enemy: 
			$Enemies.remove_child(body)
			if type == "Enemy_Boss":
				playerWin.emit()
		

func _on_projectile_despawn(projectile: Node2D) -> void:
	#print("deapwning projectile: %s" % [projectile])
	$Projectiles.remove_child(projectile)
	
	
func _on_enemny_projectile_despawn(projectile: Node2D) -> void:
	#print("deapwning projectile: %s" % [projectile])
	$EnemyProjectiles.remove_child(projectile)
	
func _on_player_death() -> void:
	playerLose.emit()



func _spawn_enemy_projectiles(body:Node2D) -> void:
	#get markers
	var markers:Node2D = marker_scene.instantiate()
	$Enemies/Markers/Box.add_child(markers)
	if markers.has_method("_sprial"):
		markers._sprial(10,1, "square_")
	
		for marker in markers.find_child("Spawns").get_children():
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
			emProjectile.find_child("despawnTimer").start(2)
	pass


func _on_timer_timeout() -> void:
	var child = $Enemies.find_child("Square")
	_spawn_enemy_projectiles(child)
