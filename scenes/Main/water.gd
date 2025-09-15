extends Node2D

func _ready():
	var rearLayer = $RearLayer/WaterPolygon
	var frontLayer = $FrontLayer/WaterPolygon
	
	if rearLayer and rearLayer.material:
		rearLayer.material = rearLayer.material.duplicate()
		rearLayer.material.set_shader_parameter("opacity", 1.0)
		
	if frontLayer and frontLayer.material:
		frontLayer.material = frontLayer.material.duplicate()
		frontLayer.material.set_shader_parameter("opacity", 0.3)
