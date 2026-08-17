extends Control


enum MovementMode {
	NONE,
	SCROLL_LEFT,
	SCROLL_RIGHT,
	BOUNCE_HORIZONTAL,
	BOUNCE_VERTICAL
}


enum TextEffect {
	NONE,
	SINE_WAVE
}


enum ColorEffect {
	STATIC,
	FADE,
	CYCLE
}


@export_group("Text")

@export_multiline var textContent: String = "HELLO WORLD"

@export var textFont: Font

@export_range(8, 200, 1)
var fontSize: int = 32

@export_range(0.0, 50.0, 1.0)
var characterSpacing: float = 0.0


@export_group("Movement")

@export var movementMode: MovementMode = MovementMode.NONE

@export_range(0.0, 1000.0, 1.0)
var movementSpeed: float = 100.0

@export_range(0.0, 500.0, 1.0)
var bounceDistance: float = 30.0

@export_range(0.0, 20.0, 0.1)
var bounceSpeed: float = 3.0


@export_group("Text Effect")

@export var textEffect: TextEffect = TextEffect.NONE

@export_range(0.0, 200.0, 1.0)
var sineAmplitude: float = 20.0

@export_range(0.0, 10.0, 0.1)
var sineFrequency: float = 0.6

@export_range(0.0, 20.0, 0.1)
var sineSpeed: float = 4.0


@export_group("Color")

@export var colorEffect: ColorEffect = ColorEffect.STATIC

@export var primaryColor: Color = Color.WHITE
@export var secondaryColor: Color = Color.RED

@export_range(0.0, 20.0, 0.1)
var colorSpeed: float = 2.0


var characterContainer: Control

var characters: Array[Label] = []

var effectTime: float = 0.0
var startingPosition: Vector2
var textWidth: float = 0.0


func _ready() -> void:
	createCharacterContainer()

	startingPosition = characterContainer.position

	buildText()


func _process(delta: float) -> void:
	effectTime += delta

	updateMovement(delta)
	updateTextEffect()
	updateColorEffect()


func createCharacterContainer() -> void:
	characterContainer = Control.new()

	characterContainer.name = "CharacterContainer"

	add_child(characterContainer)

	characterContainer.position = Vector2.ZERO
	characterContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE


func buildText() -> void:
	for character in characters:
		character.queue_free()

	characters.clear()

	textWidth = 0.0

	var currentX: float = 0.0

	for characterIndex in range(textContent.length()):
		var characterLabel := Label.new()

		characterLabel.text = textContent[characterIndex]
		characterLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE

		if textFont != null:
			characterLabel.add_theme_font_override(
				"font",
				textFont
			)

		characterLabel.add_theme_font_size_override(
			"font_size",
			fontSize
		)

		characterLabel.add_theme_color_override(
			"font_color",
			primaryColor
		)

		characterContainer.add_child(characterLabel)

		var characterSize: Vector2 = characterLabel.get_minimum_size()

		characterLabel.position = Vector2(
			currentX,
			0.0
		)

		characterLabel.size = characterSize

		currentX += characterSize.x + characterSpacing

		characters.append(characterLabel)

	textWidth = currentX


func updateMovement(delta: float) -> void:
	match movementMode:

		MovementMode.NONE:
			characterContainer.position = startingPosition

		MovementMode.SCROLL_LEFT:
			characterContainer.position.x -= movementSpeed * delta

			if characterContainer.global_position.x + textWidth < 0.0:
				characterContainer.position.x = getRightSpawnPosition()

		MovementMode.SCROLL_RIGHT:
			characterContainer.position.x += movementSpeed * delta

			if characterContainer.global_position.x > get_viewport_rect().size.x:
				characterContainer.position.x = getLeftSpawnPosition()

		MovementMode.BOUNCE_HORIZONTAL:
			characterContainer.position.x = (
				startingPosition.x
				+ sin(effectTime * bounceSpeed)
				* bounceDistance
			)

			characterContainer.position.y = startingPosition.y

		MovementMode.BOUNCE_VERTICAL:
			characterContainer.position.x = startingPosition.x

			characterContainer.position.y = (
				startingPosition.y
				+ sin(effectTime * bounceSpeed)
				* bounceDistance
			)
			


func updateTextEffect() -> void:
	for characterIndex in range(characters.size()):
		var character: Label = characters[characterIndex]

		match textEffect:

			TextEffect.NONE:
				character.position.y = 0.0

			TextEffect.SINE_WAVE:
				character.position.y = (
					sin(
						effectTime * sineSpeed
						+ characterIndex * sineFrequency
					)
					* sineAmplitude
				)


func updateColorEffect() -> void:
	match colorEffect:

		ColorEffect.STATIC:
			for character in characters:
				character.add_theme_color_override(
					"font_color",
					primaryColor
				)

		ColorEffect.FADE:
			var fadeAmount: float = (
				sin(effectTime * colorSpeed) + 1.0
			) * 0.5

			var currentColor: Color = primaryColor.lerp(
				secondaryColor,
				fadeAmount
			)

			for character in characters:
				character.add_theme_color_override(
					"font_color",
					currentColor
				)

		ColorEffect.CYCLE:
			for characterIndex in range(characters.size()):
				var character: Label = characters[characterIndex]

				var hue: float = fmod(
					effectTime * colorSpeed * 0.1
					+ float(characterIndex)
					/ max(float(characters.size()), 1.0),
					1.0
				)

				character.add_theme_color_override(
					"font_color",
					Color.from_hsv(
						hue,
						1.0,
						1.0
					)
				)
				
func getRightSpawnPosition() -> float:
	var viewportWidth: float = get_viewport_rect().size.x
	return viewportWidth - global_position.x

func getLeftSpawnPosition() -> float:
	return -global_position.x - textWidth
