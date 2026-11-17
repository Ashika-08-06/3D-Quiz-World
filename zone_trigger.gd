extends Area3D

@export var zone_id: String = ""

var quiz_started := false


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if quiz_started:
		return

	# If zone_id is empty, identify the room from this trigger's name
	if zone_id == "":
		if name == "ZoneTrigger_Math":
			zone_id = "math"
		elif name == "ZoneTrigger_Logic":
			zone_id = "logic"
		elif name == "ZoneTrigger_Coding":
			zone_id = "coding"
		elif name == "ZoneTrigger_Electronics":
			zone_id = "electronics"

	if zone_id == "":
		print("ERROR: No zone assigned to ", name)
		return

	quiz_started = true

	print("================================")
	print("PLAYER REACHED DOOR: ", zone_id)
	print("Starting quiz...")
	print("================================")

	QuizManager.start_quiz(zone_id)


func _on_body_exited(body):
	if body.is_in_group("player"):
		# Allow the trigger to work again if the player comes back
		quiz_started = false
