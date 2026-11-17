extends Area3D

@onready var completion_label = get_node("/root/Main/QuizUI/CompletionLabel")


func _ready():
	completion_label.visible = false
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):

		print("🧠 Logic Reward Collected!")

		get_parent().visible = false

		# Safely disable the reward area
		set_deferred("monitoring", false)

		completion_label.text = "🎉 Logic Zone Completed!\n🧠 Reward Collected!"
		completion_label.visible = true

		await get_tree().create_timer(3.0).timeout
		completion_label.visible = false
