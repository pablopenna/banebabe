extends CanvasLayer

@export
var banebabe_to_track: Banebabe

@export
var _speed_bar: ProgressBar

func _physics_process(_delta: float) -> void:
	_speed_bar.value = banebabe_to_track.move_speed / banebabe_to_track.max_move_speed
