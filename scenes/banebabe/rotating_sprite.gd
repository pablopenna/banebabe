extends Sprite2D

var rotation_speed := 2000

func _physics_process(delta: float) -> void:
	rotate(rotation_speed * delta)
	
