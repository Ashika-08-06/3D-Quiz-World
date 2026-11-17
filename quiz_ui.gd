extends CanvasLayer   
   
@onready var quiz_panel = $QuizPanel   
@onready var question_label = $QuizPanel/QuestionLabel   
@onready var option1 = $QuizPanel/Option1   
@onready var option2 = $QuizPanel/Option2   
@onready var option3 = $QuizPanel/Option3   
@onready var option4 = $QuizPanel/Option4   
   
@onready var score_label = $ScoreLabel   
@onready var progress_label = $ProgressLabel   
@onready var completion_label = $CompletionLabel  
  
# -----------------------------  
# AUDIO  
# -----------------------------  
@onready var background_music = $"../BackgroundMusic"  
@onready var correct_sound = $"../CorrectSound"  
@onready var wrong_sound = $"../WrongSound"  
@onready var complete_sound = $"../CompleteSound"  
   
   
func _ready():   
	quiz_panel.visible = false   
	completion_label.visible = false  
  
	# -----------------------------  
	# BACKGROUND MUSIC  
	# -----------------------------  
	if background_music.stream != null: 
		if not background_music.playing:  
			background_music.play()  
   
	# -----------------------------  
	# QUIZ PANEL - DARK GAME UI   
	# -----------------------------   
	var panel_style = StyleBoxFlat.new()   
	panel_style.bg_color = Color("#111827")   
	panel_style.border_color = Color("#3b82f6")   
	panel_style.set_border_width_all(2)   
	panel_style.corner_radius_top_left = 18   
	panel_style.corner_radius_top_right = 18   
	panel_style.corner_radius_bottom_left = 18   
	panel_style.corner_radius_bottom_right = 18   
	panel_style.content_margin_left = 30   
	panel_style.content_margin_right = 30   
	panel_style.content_margin_top = 25   
	panel_style.content_margin_bottom = 25   
   
	quiz_panel.add_theme_stylebox_override("panel", panel_style)   
   
   
	# -----------------------------   
	# QUESTION   
	# -----------------------------   
	question_label.add_theme_font_size_override("font_size", 26)   
	question_label.add_theme_color_override(   
		"font_color",   
		Color("#f8fafc")   
	)   
   
	question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER   
	question_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER   
   
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART   
	question_label.clip_text = false   
	question_label.custom_minimum_size = Vector2(360, 0)   
   
   
	# -----------------------------   
	# ANSWER BUTTON STYLE   
	# -----------------------------   
	var button_style = StyleBoxFlat.new()   
	button_style.bg_color = Color("#1f2937")   
	button_style.corner_radius_top_left = 8   
	button_style.corner_radius_top_right = 8   
	button_style.corner_radius_bottom_left = 8   
	button_style.corner_radius_bottom_right = 8   
   
	var hover_style = StyleBoxFlat.new()   
	hover_style.bg_color = Color("#2563eb")   
	hover_style.corner_radius_top_left = 8   
	hover_style.corner_radius_top_right = 8   
	hover_style.corner_radius_bottom_left = 8   
	hover_style.corner_radius_bottom_right = 8   
   
	for button in [option1, option2, option3, option4]:   
		button.add_theme_font_size_override("font_size", 20)   
		button.add_theme_color_override("font_color", Color("#ffffff"))   
		button.add_theme_stylebox_override("normal", button_style)   
		button.add_theme_stylebox_override("hover", hover_style)   
		button.add_theme_stylebox_override("pressed", hover_style)   
   
   
	# -----------------------------   
	# SCORE / PROGRESS   
	# -----------------------------   
	score_label.add_theme_font_size_override("font_size", 22)   
	progress_label.add_theme_font_size_override("font_size", 22)   
   
	score_label.add_theme_color_override(   
		"font_color",   
		Color("#facc15")   
	)   
   
	progress_label.add_theme_color_override(   
		"font_color",   
		Color("#ffffff")   
	)   
   
	# -----------------------------   
	# COMPLETION LABEL STYLE  
	# -----------------------------   
	completion_label.add_theme_font_size_override("font_size", 28)   
	completion_label.add_theme_color_override(   
		"font_color",   
		Color("#22c55e")   
	)   
	completion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER   
   
   
	# -----------------------------   
	# SIGNALS   
	# -----------------------------   
	if not QuizManager.question_ready.is_connected(_on_question_ready):   
		QuizManager.question_ready.connect(_on_question_ready)   
   
	if not QuizManager.answer_result.is_connected(_on_answer_result):   
		QuizManager.answer_result.connect(_on_answer_result)   
   
	if not QuizManager.zone_completed.is_connected(_on_zone_completed):   
		QuizManager.zone_completed.connect(_on_zone_completed)   
   
	if not QuizManager.quiz_hidden.is_connected(_on_quiz_hidden):   
		QuizManager.quiz_hidden.connect(_on_quiz_hidden)   
   
	option1.pressed.connect(func(): _submit_answer(0))   
	option2.pressed.connect(func(): _submit_answer(1))   
	option3.pressed.connect(func(): _submit_answer(2))   
	option4.pressed.connect(func(): _submit_answer(3))   
   
	_update_ui()   
   
   
func _on_question_ready(question):   
	quiz_panel.visible = true   
	completion_label.visible = false   
   
	# Question text   
	if question.has("question"):   
		question_label.text = str(question["question"])   
	elif question.has("question_text"):   
		question_label.text = str(question["question_text"])   
   
	# Answers   
	var options = question.get("options", [])   
   
	if options.size() >= 4:   
		option1.text = "A.  " + str(options[0])   
		option2.text = "B.  " + str(options[1])   
		option3.text = "C.  " + str(options[2])   
		option4.text = "D.  " + str(options[3])   
   
	_enable_buttons()   
	_update_ui()   
   
   
func _submit_answer(index):   
	_disable_buttons()   
	QuizManager.check_answer(index)   
   
   
func _on_answer_result(correct):  
  
	# -----------------------------  
	# CORRECT / WRONG SOUND  
	# -----------------------------  
	if correct:  
		if correct_sound.stream != null: 
			correct_sound.play()  
	else:  
		if wrong_sound.stream != null: 
			wrong_sound.play()  
  
	_update_ui()   
   
	# Show Correct/Wrong feedback  
	if correct:   
		question_label.text = "✓ Correct!"   
		question_label.add_theme_color_override("font_color", Color("#4ade80"))   
	else:   
		question_label.text = "✗ Wrong! Try Again."   
		question_label.add_theme_color_override("font_color", Color("#f87171"))   
   
	await get_tree().create_timer(0.8).timeout   
   
	question_label.add_theme_color_override("font_color", Color("#f8fafc"))   
   
	if quiz_panel.visible:   
		_enable_buttons()   
   
   
func _on_zone_completed(zone_id: String):   
  
	# Play completion sound 
	if complete_sound.stream != null: 
		complete_sound.play() 
  
	quiz_panel.visible = false   
	completion_label.text = "Zone Complete: " + zone_id.capitalize() + "!"   
	completion_label.visible = true   
	_update_ui()   
   
	await get_tree().create_timer(2.0).timeout   
	completion_label.visible = false   
   
   
func _on_quiz_hidden():   
	quiz_panel.visible = false   
   
   
func _update_ui():   
	score_label.text = "⭐ Score: " + str(QuizManager.score)   
   
	if "completed_zones" in QuizManager:   
		progress_label.text = "Zones: %d / 4" % QuizManager.completed_zones.size()   
   
   
func _enable_buttons():   
	option1.disabled = false   
	option2.disabled = false   
	option3.disabled = false   
	option4.disabled = false   
   
   
func _disable_buttons():   
	option1.disabled = true   
	option2.disabled = true   
	option3.disabled = true   
	option4.disabled = true   
   
   
func hide_quiz():   
	quiz_panel.visible = false
