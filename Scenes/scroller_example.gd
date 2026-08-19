extends Control


@export var textController: TextController


func _ready() -> void:
	if textController == null:
		push_error("TextControllerDemo: TextController has not been assigned.")
		return

	runDemo()


func runDemo() -> void:
	# -------------------------------------------------
	# 1. STATIC TEXT
	# -------------------------------------------------

	setDemoText("GODOT TEXT CONTROLLER")

	textController.movementMode = TextController.MovementMode.NONE
	textController.textEffect = TextController.TextEffect.NONE
	textController.colorEffect = TextController.ColorEffect.STATIC

	textController.primaryColor = Color.WHITE

	await get_tree().create_timer(4.0).timeout


	# -------------------------------------------------
	# 2. SCROLL LEFT
	# -------------------------------------------------

	setDemoText("SCROLLING LEFT")

	textController.movementMode = TextController.MovementMode.SCROLL_LEFT
	textController.movementSpeed = 180.0

	textController.textEffect = TextController.TextEffect.NONE
	textController.colorEffect = TextController.ColorEffect.STATIC

	resetTextPosition()

	await get_tree().create_timer(6.0).timeout


	# -------------------------------------------------
	# 3. SCROLL RIGHT
	# -------------------------------------------------

	setDemoText("AND BACK THE OTHER WAY")

	textController.movementMode = TextController.MovementMode.SCROLL_RIGHT
	textController.movementSpeed = 180.0

	resetTextPosition()

	await get_tree().create_timer(6.0).timeout


	# -------------------------------------------------
	# 4. VERTICAL BOUNCE
	# -------------------------------------------------

	setDemoText("VERTICAL BOUNCE")

	textController.movementMode = TextController.MovementMode.BOUNCE_VERTICAL

	textController.bounceDistance = 40.0
	textController.bounceSpeed = 3.0

	resetTextPosition()

	await get_tree().create_timer(5.0).timeout


	# -------------------------------------------------
	# 5. HORIZONTAL BOUNCE
	# -------------------------------------------------

	setDemoText("HORIZONTAL BOUNCE")

	textController.movementMode = TextController.MovementMode.BOUNCE_HORIZONTAL

	textController.bounceDistance = 80.0
	textController.bounceSpeed = 3.0

	resetTextPosition()

	await get_tree().create_timer(5.0).timeout


	# -------------------------------------------------
	# 6. SINE WAVE
	# -------------------------------------------------

	setDemoText("WELCOME BACK TO 1987")

	textController.movementMode = TextController.MovementMode.NONE

	textController.textEffect = TextController.TextEffect.SINE_WAVE

	textController.sineAmplitude = 30.0
	textController.sineFrequency = 0.55
	textController.sineSpeed = 4.0

	resetTextPosition()

	await get_tree().create_timer(6.0).timeout


	# -------------------------------------------------
	# 7. SCROLLING SINE WAVE
	# -------------------------------------------------

	setDemoText("SCROLLING SINE WAVE")

	textController.movementMode = TextController.MovementMode.SCROLL_LEFT
	textController.movementSpeed = 160.0

	textController.textEffect = TextController.TextEffect.SINE_WAVE

	resetTextPosition()

	await get_tree().create_timer(7.0).timeout


	# -------------------------------------------------
	# 8. COLOR FADE
	# -------------------------------------------------

	setDemoText("COLOR FADE")

	textController.movementMode = TextController.MovementMode.NONE
	textController.textEffect = TextController.TextEffect.NONE

	textController.colorEffect = TextController.ColorEffect.FADE

	textController.primaryColor = Color.CYAN
	textController.secondaryColor = Color.MAGENTA
	textController.colorSpeed = 2.0

	resetTextPosition()

	await get_tree().create_timer(6.0).timeout


	# -------------------------------------------------
	# 9. COLOR CYCLE
	# -------------------------------------------------

	setDemoText("COLOR CYCLING")

	textController.colorEffect = TextController.ColorEffect.CYCLE

	await get_tree().create_timer(6.0).timeout


	# -------------------------------------------------
	# 10. FULL DEMO MODE
	# -------------------------------------------------

	setDemoText("ONE GRID AT A TIME")

	textController.movementMode = TextController.MovementMode.SCROLL_LEFT
	textController.movementSpeed = 150.0

	textController.textEffect = TextController.TextEffect.SINE_WAVE
	textController.sineAmplitude = 35.0
	textController.sineFrequency = 0.5
	textController.sineSpeed = 4.0

	textController.colorEffect = TextController.ColorEffect.CYCLE
	textController.colorSpeed = 2.5

	resetTextPosition()

	await get_tree().create_timer(10.0).timeout


	# -------------------------------------------------
	# END
	# -------------------------------------------------

	setDemoText("GODOT TEXT CONTROLLER")

	textController.movementMode = TextController.MovementMode.NONE
	textController.textEffect = TextController.TextEffect.NONE
	textController.colorEffect = TextController.ColorEffect.STATIC

	textController.primaryColor = Color.WHITE

	resetTextPosition()


func setDemoText(newText: String) -> void:
	textController.textContent = newText
	textController.buildText()

	resetTextPosition()


func resetTextPosition() -> void:
	textController.characterContainer.position = (
		textController.startingPosition
	)
