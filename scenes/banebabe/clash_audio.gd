extends AudioStreamPlayer2D

@export 
var banebabe: Banebabe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	banebabe.collided.connect(_play_clash_sound)

func _play_clash_sound():
	self.play()
