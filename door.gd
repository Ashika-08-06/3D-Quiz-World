extends StaticBody3D

@export var zone_id: String = "math"

@onready var door_mesh = $DoorMesh
@onready var collision = $CollisionShape3D


func _ready():
	# Every door starts CLOSED
	door_mesh.visible = true
	collision.disabled = false

	QuizManager.zone_completed.connect(_on_zone_completed)


func _on_zone_completed(completed_zone):
	# Open ONLY this door's zone
	if completed_zone == zone_id:
		door_mesh.visible = false
		collision.disabled = true

		print("🚪 Door opened: ", zone_id)
