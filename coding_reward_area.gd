extends Area3D
@export var zone_id: String = "coding"
var unlocked := false
@onready var completion_label = get_node("/root/Main/QuizUI/CompletionLabel")
func _ready():
	body_entered.connect(_on_body_entered)
	QuizManager.zone_completed.connect(_on_zone_completed)
	completion_label.visible = false
func _on_zone_completed(completed_zone):
	if completed_zone == zone_id:
		unlocked = true
		print("💻 Coding reward is ready to collect!")
func _on_body_entered(body):
	if body.is_in_group("player") and unlocked:
		print("💻 Coding Reward Collected!")
		get_parent().visible = false
		set_deferred("monitoring", false)
		completion_label.text = "🎉 Coding Zone Completed!\n💻 Reward Collected!"
		completion_label.visible = true
		await get_tree().create_timer(3.0).timeout
		completion_label.visible = false
