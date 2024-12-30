extends Node2D

var harpoon_scene: PackedScene = preload("res://scenes/minigames/hacking/harpoon.tscn")
var square_scene: PackedScene = preload("res://scenes/minigames/hacking/enemies/square.tscn")

signal playerWin
signal playerLose

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#create enemies
	var square:StaticBody2D = square_scene.instantiate()
	square.position = $Markers/Box.global_position
	square.connect("death", _on_enemy_death)
	$Enemies.add_child(square)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_shot_laser(pos: Vector2, player_direction: Vector2) -> void:
	var harpoon:Area2D = harpoon_scene.instantiate()
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
		"Enemy_Projectile":
			_on_projectile_hit_enemy_projectile(body, projectile)
		"Player":
			_on_projectile_hit_player(body, projectile)
		_:
			push_error("something else got hit: %s, with type: %s" % [body, body.type])

func _on_projectile_hit_enemy(enemy: StaticBody2D, projectile: Node2D) -> void:
	#print("projectile: %s, hit enemy: %s" % [projectile,enemy])
	$Projectiles.call_deferred("remove_child", projectile)
	enemy.damage(projectile.damage)
	pass

func _on_projectile_hit_enemy_projectile(enemyProjectile: Node2D, projectile: Node2D) -> void:
	print("player projectile: %s, hit enemy projectile: %s" % [projectile, enemyProjectile])
	$Projectiles.remove_child(projectile)
	projectile.disconnect("despawnTimer", _on_projectile_despawn)
	$EnemyProjectiles.remove_child(enemyProjectile)
	pass

func _on_projectile_hit_player(player: StaticBody2D, enemyProjectile: Node2D) -> void:
	print("player: %s, was hit by projectile: %s" % [player, enemyProjectile])
	#remove projectile
	#damage player
	pass

func _on_enemy_death(body: Node2D) -> void:
	print("enemy died: %s" % [body.name])
	var enemies: Array[Node] = $Enemies.get_children()
	for enemy in enemies:
		#print("enemy : %s" % enemy )
		if body == enemy: 
			$Enemies.remove_child(body)
		
	
func _on_projectile_despawn(projectile: Node2D) -> void:
	#print("deapwning projectile: %s" % [projectile])
	$Projectiles.remove_child(projectile)
