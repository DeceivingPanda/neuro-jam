extends Node2D



func _sprial(numNodes: int, radius: float, _name:String) -> void:
	for i in range(0, numNodes):
		# create a new node
		var newNode: Marker2D = Marker2D.new()
		newNode.name = str(_name, i)
		# add it beneath the current node
		$Spawns.add_child(newNode)
		# build a transform that consists of an offset, then rotation
		var nTransform = newNode.get_transform()
		# offset upwards based on the radius
		nTransform = nTransform.translated( Vector2( 0.0, -radius ) )
		# rotate (around 0,0) based on the angle between each node
		nTransform = nTransform.rotated( i*2*PI / float(numNodes))
		# update the node transform
		newNode.transform = nTransform
