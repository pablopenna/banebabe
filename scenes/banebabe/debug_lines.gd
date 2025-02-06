extends Node2D

@export 
var banebabe: Banebabe

var line_length

func _draw() -> void:
	# current direction
	draw_line(Vector2.ZERO, banebabe.velocity, Color.GREEN, 1.0)
	# target direction
	draw_line(Vector2.ZERO, banebabe.driver.get_target_direction() * 100, Color.RED, 1.0)
	
func _physics_process(_delta: float) -> void:
	queue_redraw()
