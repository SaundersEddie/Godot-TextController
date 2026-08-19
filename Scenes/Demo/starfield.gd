extends Control


@export var farStarCount: int = 80
@export var midStarCount: int = 50
@export var nearStarCount: int = 30

@export var farSpeed: float = 20.0
@export var midSpeed: float = 45.0
@export var nearSpeed: float = 90.0


var farStars: Array[Vector2] = []
var midStars: Array[Vector2] = []
var nearStars: Array[Vector2] = []


func _ready() -> void:
	randomize()

	createStars(farStars, farStarCount)
	createStars(midStars, midStarCount)
	createStars(nearStars, nearStarCount)


func _process(delta: float) -> void:
	moveStars(farStars, farSpeed, delta)
	moveStars(midStars, midSpeed, delta)
	moveStars(nearStars, nearSpeed, delta)

	queue_redraw()


func createStars(starArray: Array[Vector2], count: int) -> void:
	var screenSize := get_viewport_rect().size

	for i in range(count):
		starArray.append(
			Vector2(
				randf_range(0.0, screenSize.x),
				randf_range(0.0, screenSize.y)
			)
		)


func moveStars(
	starArray: Array[Vector2],
	speed: float,
	delta: float
) -> void:
	var screenSize := get_viewport_rect().size

	for i in range(starArray.size()):
		starArray[i].x -= speed * delta

		if starArray[i].x < 0.0:
			starArray[i].x = screenSize.x
			starArray[i].y = randf_range(0.0, screenSize.y)


func _draw() -> void:
	var time := Time.get_ticks_msec() / 1000.0

	for i in range(farStars.size()):
		var star := farStars[i]
		var twinkle := 0.35 + sin(time * 1.5 + i * 0.7) * 0.12

		draw_circle(
			star,
			1.0,
			Color(twinkle, twinkle, twinkle)
		)

	for i in range(midStars.size()):
		var star := midStars[i]
		var twinkle := 0.65 + sin(time * 2.0 + i * 0.9) * 0.18

		draw_circle(
			star,
			1.5,
			Color(twinkle, twinkle, twinkle)
		)

	for i in range(nearStars.size()):
		var star := nearStars[i]
		var twinkle := 0.85 + sin(time * 2.8 + i * 1.1) * 0.15

		draw_circle(
			star,
			2.0,
			Color(twinkle, twinkle, twinkle)
		)
