extends Control

@onready var textController = $TextController
@onready var demoMusic = $AudioStreamPlayer

func _ready() -> void:
	demoMusic.play()

	# TITLE
	setDemoText("GODOT TEXT CONTROLLER")
	textController.modulate.a = 0.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	await fadeText(1.0, 0.0, 0.5)

	# QUICK DESCRIPTION
	setDemoText("REUSABLE ANIMATED TEXT FOR GODOT 4")
	await fadeText(0.0, 1.0, 1.0)
	await get_tree().create_timer(3.5).timeout
	await fadeText(1.0, 0.0, 1.0)

	# FEATURE OVERVIEW
	setDemoText("SCROLLING  -  BOUNCE  -  SINE WAVE  -  COLOR")
	await fadeText(0.0, 1.0, 1.0)
	await get_tree().create_timer(3.5).timeout
	await fadeText(1.0, 0.0, 1.0)
	
	# SCROLL LEFT - This appears on the drum roll - Do not change timing above
	setDemoText("SCROLL LEFT")
	await fadeText(0.0, 1.0, 0.5)
	textController.movementMode = textController.MovementMode.SCROLL_LEFT
	textController.movementSpeed = 300.0
	await get_tree().create_timer(5.00).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# SCROLL RIGHT
	setDemoText("SCROLL RIGHT")
	textController.movementMode = textController.MovementMode.SCROLL_RIGHT
	textController.movementSpeed = 300.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.5).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# VERTICAL BOUNCE
	resetEffects()
	setDemoText("VERTICAL BOUNCE")
	textController.movementMode = textController.MovementMode.BOUNCE_VERTICAL
	textController.bounceDistance = 80.0
	textController.bounceSpeed = 3.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# HORIZONTAL BOUNCE
	resetEffects()
	setDemoText("HORIZONTAL BOUNCE")
	textController.movementMode = textController.MovementMode.BOUNCE_HORIZONTAL
	textController.bounceDistance = 120.0
	textController.bounceSpeed = 3.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# SINE WAVE
	resetEffects()
	setDemoText("SINE WAVE")
	textController.textEffect = textController.TextEffect.SINE_WAVE
	textController.sineAmplitude = 30.0
	textController.sineFrequency = 0.55
	textController.sineSpeed = 4.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# SCROLLING SINE WAVE
	resetEffects()
	setDemoText("SCROLLING SINE WAVE")
	textController.movementMode = textController.MovementMode.SCROLL_LEFT
	textController.movementSpeed = 300.0
	textController.textEffect = textController.TextEffect.SINE_WAVE
	textController.sineAmplitude = 30.0
	textController.sineFrequency = 0.55
	textController.sineSpeed = 4.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(3.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# COLOR FADE
	resetEffects()
	setDemoText("COLOR FADE")
	textController.colorEffect = textController.ColorEffect.FADE
	textController.primaryColor = Color.CYAN
	textController.secondaryColor = Color.MAGENTA
	textController.colorSpeed = 2.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# COLOR CYCLE
	resetEffects()
	setDemoText("COLOR CYCLE")
	textController.colorEffect = textController.ColorEffect.CYCLE
	textController.colorSpeed = 2.0
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(4.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	# Whats Coming
	resetEffects()
	setDemoText("UPCOMING TO THE REPO")
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	setDemoText("VERTICAL SCROLL - FULL TEXT FADE")
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	await fadeText(1.0, 0.0, 0.5)
	
	setDemoText("SINE WAVE BOUNCE SCROLL")
	await fadeText(0.0, 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
	await fadeText(1.0, 0.0, 0.5)

	# Everything We have :D
	resetEffects()
	setDemoText("WELCOME BACK TO THE LATE 1900s")
	textController.movementMode = textController.MovementMode.SCROLL_RIGHT
	textController.movementSpeed = 157.0
	textController.textEffect = textController.TextEffect.SINE_WAVE
	textController.sineAmplitude = 35.0
	textController.sineFrequency = 0.5
	textController.sineSpeed = 4.0
	textController.colorEffect = textController.ColorEffect.CYCLE
	textController.colorSpeed = 2.5
	await get_tree().create_timer(18.0).timeout
	textController.movementSpeed = 0.0
	await get_tree().create_timer(3.0).timeout
	await fadeText(1.0, 0.0, 4.0)

func setDemoText(newText: String) -> void:
	textController.textContent = newText
	textController.buildText()

	var screenSize = get_viewport_rect().size

	textController.position.x = ( (screenSize.x - textController.textWidth) / 2.0 )
	textController.position.y = screenSize.y / 2.0

func resetEffects() -> void:
	textController.movementMode = textController.MovementMode.NONE
	textController.textEffect = textController.TextEffect.NONE
	textController.colorEffect = textController.ColorEffect.STATIC

	textController.primaryColor = Color.WHITE
	textController.modulate.a = 1.0


func fadeText(
	fromAlpha: float,
	toAlpha: float,
	duration: float
) -> void:
	textController.modulate.a = fromAlpha

	var tween = create_tween()

	tween.tween_property(
		textController,
		"modulate:a",
		toAlpha,
		duration
	)

	await tween.finished
