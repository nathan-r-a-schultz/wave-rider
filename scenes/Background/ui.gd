extends Control

var radToTransparency := PI / 2

func _ready():
	
	if Global.titleInfo[0] != -1:
		radToTransparency = Global.titleInfo[0]
	else:
		$Logo.queue_free()
		$StartInfo.queue_free()
		$Credit.queue_free()

func _physics_process(_delta):
	
	if Global.titleInfo[0] != -1:
		radToTransparency += PI * _delta
		$StartInfo.modulate = Color(1, 1, 1, (sin(radToTransparency) + 1) / 2)
	
		$Logo.position.x -= 2 * Global.scrollSpeed * _delta
		$StartInfo.position.x -= 2 * Global.scrollSpeed * _delta
		$Credit.position.x -= 2 * Global.scrollSpeed * _delta
		
		if $Logo.position.x <= -$Logo.size.x + -((get_viewport_rect().size.x - 320) / 2):
			$Logo.queue_free()
			$StartInfo.queue_free()
			$Credit.queue_free()
			Global.titleInfo = [-1]
