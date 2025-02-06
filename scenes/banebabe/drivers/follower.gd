extends Driver

@export
var target: Node2D

func get_target_direction() -> Vector2:
	return global_position.direction_to(target.global_position)

func is_accelerating() -> bool:
	return false;
	
func is_drift_input() -> bool:
	return false
