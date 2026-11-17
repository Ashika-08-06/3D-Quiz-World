extends Area3D

var quiz_started := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if quiz_started:
		return

	quiz_started = true

	print("Electronics door reached")

	QuizManager.start_quiz("electronics")

func _on_body_exited(body):
	if body.is_in_group("player"):
		quiz_started = false
		QuizManager.hide_quiz()
