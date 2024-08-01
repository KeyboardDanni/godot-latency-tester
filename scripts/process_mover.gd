extends Node2D

var startX;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startX = position.x;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var offset = Engine.get_process_frames() % 10;
	position.x = startX + offset * 64;
