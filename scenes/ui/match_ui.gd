extends CanvasLayer
# IMPORTANT: Threshold bars should have same anchor points as the speed bar. This is an assumption in the code

@export
var banebabe_to_track: Banebabe

@export
var _speed_bar: ProgressBar

@export
var _min_threshold_bar: ProgressBar

@export
var _max_threshold_bar: ProgressBar

func _ready() -> void:
	_setup_threshold_bar(_min_threshold_bar, banebabe_to_track.drifting_lower_threshold)
	_setup_threshold_bar(_max_threshold_bar, banebabe_to_track.drifting_upper_threshold)

func _physics_process(_delta: float) -> void:
	_speed_bar.value = banebabe_to_track.move_speed / banebabe_to_track.max_move_speed

func _setup_threshold_bar(threshold_bar: ProgressBar, threshold_value: float) -> void:
	var threshold_bar_length := threshold_bar.anchor_right - threshold_bar.anchor_left
	var max_value := banebabe_to_track.max_move_speed
	var desired_length := (threshold_bar_length / max_value) * threshold_value
	threshold_bar.anchor_right = threshold_bar.anchor_left + desired_length
