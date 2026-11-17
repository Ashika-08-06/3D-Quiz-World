extends Area3D

@onready var completion_label = get_node("/root/Main/QuizUI/CompletionLabel")


func _ready():
	body_entered.connect(_on_body_entered)
	completion_label.visible = false


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("⭐ Math Reward Collected!")

		get_parent().visible = false

		completion_label.text = "🎉 Math Zone Completed!\n⭐ Reward Collected!"
		completion_label.visible = true

		await get_tree().create_timer(3.0).timeout
		completion_label.visible = false
