# Godot TextController

A reusable, self-contained text controller for Godot 4.x.

The goal of `TextController` is to provide a drop-in scene for animated game text without requiring additional child nodes, scripts, or setup in the parent scene.

The controller currently supports:

- Static text
- Left scrolling
- Right scrolling
- Horizontal bouncing
- Vertical bouncing
- Character-by-character sine-wave movement
- Static text color
- Two-color fading
- Per-character color cycling
- Combining movement, text effects, and color effects

The internal character nodes are generated automatically at runtime.

---

## Folder Structure

Recommended structure:

```text
TextController/
├── textController.tscn
├── textController.gd
└── README.md
```

Copy the entire `TextController` folder into any Godot project.

---

## Scene Setup

The reusable scene should contain only one node:

```text
TextController [Control]
```

Attach:

```text
textController.gd
```

to the `TextController` root.

No child nodes need to be created manually.

At runtime, the controller automatically creates:

```text
TextController
└── CharacterContainer
	├── Label
	├── Label
	├── Label
	└── ...
```

Each character is rendered as an individual `Label`.

This allows effects such as character-by-character sine waves and individual color cycling.

---

## Basic Use

1. Add or instantiate `textController.tscn` in your scene.
2. Position the `TextController` node where you want the text baseline to begin.
3. Enter the required text in `Text Content`.
4. Select the movement, text effect, and color effect in the Inspector.
5. Run the scene.

The internal `CharacterContainer` and character labels are generated automatically.

---

# Inspector Settings

## Text

### Text Content

The string displayed by the controller.

Example:

```text
HELLO FROM GODOT
```

### Text Font

Optional custom Godot font resource.

If no font is supplied, the project/default Godot font is used.

### Font Size

Size of the generated character labels.

### Character Spacing

Additional horizontal spacing inserted between characters.

A value of `0` uses the natural width of each character.

---

# Movement

Movement controls the position of the entire text string.

Movement and text effects are independent and may be combined.

## None

The text remains at its starting position.

## Scroll Left

Moves the entire text string from right to left.

The text is considered off-screen only after the final character has completely passed the left edge of the viewport.

It then respawns just beyond the right edge.

## Scroll Right

Moves the entire text string from left to right.

After the text completely leaves the right edge, it respawns beyond the left edge.

## Bounce Horizontal

Moves the complete text string left and right around its starting position.

### Movement Speed

Speed used by scrolling modes.

### Bounce Distance

Maximum distance from the original position when using a bounce movement mode.

### Bounce Speed

Speed of the horizontal or vertical bounce.

---

# Text Effects

Text effects operate on individual characters.

They can be combined with movement modes.

For example:

```text
Movement: Scroll Left
Text Effect: Sine Wave
```

produces a traditional C64/demo-style sine-wave scroller.

## None

Characters remain on their normal baseline.

## Sine Wave

Each character receives an independent vertical offset.

The offset is based on:

```text
time + character position
```

which causes the wave to travel through the text.

### Sine Amplitude

Maximum vertical distance a character moves from the baseline.

Higher values create a taller wave.

### Sine Frequency

Controls the phase difference between neighboring characters.

Lower values create a long smooth wave.

Higher values create tighter waves.

### Sine Speed

Controls how quickly the wave travels through the characters.

---

# Color Effects

Color effects are independent of movement and character effects.

## Static

All characters use `Primary Color`.

## Fade

The complete text smoothly fades between:

```text
Primary Color
Secondary Color
```

and back again.

### Color Speed

Controls how quickly the fade occurs.

## Cycle

Each character receives a changing HSV color based on its position and time.

This creates a moving rainbow/color-cycle effect across the text.

`Color Speed` controls the animation speed.

---

# Combining Effects

Movement, character animation, and color animation are deliberately separate systems.

This allows combinations such as:

## Standard Scroller

```text
Movement: Scroll Left
Text Effect: None
Color Effect: Static
```

## Bouncing Title

```text
Movement: Bounce Vertical
Text Effect: None
Color Effect: Static
```

## Color-Fading Title

```text
Movement: None
Text Effect: None
Color Effect: Fade
```

## C64-Style Sine Scroller

```text
Movement: Scroll Left
Text Effect: Sine Wave
Color Effect: Static
```

## Full Demo-Scene Nonsense

```text
Movement: Scroll Left
Text Effect: Sine Wave
Color Effect: Cycle
```

Use responsibly.

Or don't.

---

# Recommended Initial Test

Before combining effects, test the controller one system at a time.

## Test 1 — Static Text

```text
Text Content: HELLO WORLD
Font Size: 48

Movement: None
Text Effect: None
Color Effect: Static
```

Expected result:

The text appears and does not move.

---

## Test 2 — Vertical Bounce

```text
Movement: Bounce Vertical
Bounce Distance: 30
Bounce Speed: 3

Text Effect: None
Color Effect: Static
```

Expected result:

The entire text string moves vertically as one unit.

---

## Test 3 — Sine Wave

```text
Movement: None

Text Effect: Sine Wave
Sine Amplitude: 20
Sine Frequency: 0.6
Sine Speed: 4
```

Expected result:

Individual characters move vertically at different phases.

---

## Test 4 — Scroll Left

```text
Movement: Scroll Left
Movement Speed: 100

Text Effect: None
Color Effect: Static
```

Expected result:

The text scrolls completely off the left side of the viewport before respawning beyond the right side.

No character should disappear early.

No character should visibly appear at the opposite edge during respawn.

---

## Test 5 — Combined Effects

```text
Movement: Scroll Left
Text Effect: Sine Wave
Color Effect: Cycle
```

Expected result:

The text scrolls horizontally while individual characters follow a sine wave and cycle through colors.

---

# Debugging

Because the controller creates its child nodes at runtime, they will not normally appear in the editor scene tree.

While the game is running, switch the Scene dock from:

```text
Local
```

to:

```text
Remote
```

You should see something similar to:

```text
TextController
└── CharacterContainer
    ├── Label
    ├── Label
    ├── Label
    └── ...
```

The number of generated labels should approximately match the number of characters in `Text Content`.

---

# Design Notes

## Why CharacterContainer Is Created in Code

`CharacterContainer` is an internal implementation detail.

Users of the scene should not have to:

- Create it
- Position it
- Size it
- Anchor it
- Attach scripts to it
- Know that it exists

The public component is:

```text
TextController
```

Everything below that node is managed internally.

This keeps the scene genuinely portable between projects.

---

## Why Each Character Is a Separate Label

A standard Godot `Label` renders an entire string as one control.

That works well for normal scrolling but prevents independent character movement.

Using one label per character allows:

- Sine waves
- Character bouncing
- Character rotation
- Individual color effects
- Future ripple effects
- Future staggered animation
- Future per-character scaling

The entire set of characters is placed inside `CharacterContainer`.

Large-scale movement such as scrolling or bouncing moves the container.

Character-specific effects modify the individual labels.

---

# Coordinate Handling

Scrolling uses viewport/global positions to determine when text has actually left the visible screen.

This is important because `TextController` itself may be positioned somewhere other than X = 0.

The controller must not assume that its local coordinate system is identical to the viewport coordinate system.

The intended behavior is:

### Scroll Left

1. Move the character container left.
2. Wait until the final character has completely passed X = 0.
3. Respawn the text completely beyond the right side of the viewport.

### Scroll Right

1. Move the character container right.
2. Wait until the first character has completely passed the right side of the viewport.
3. Respawn the complete string beyond the left side.

The controller should therefore behave correctly regardless of where the `TextController` node itself is positioned.

---

# Current Limitations

This is an early reusable version of the controller.

Current limitations include:

- Inspector changes to `Text Content` during runtime do not yet rebuild the generated characters.
- Text wrapping is not currently supported.
- Multi-line animation has not yet been implemented.
- Character rotation effects have not yet been implemented.
- Per-character bounce/ripple modes have not yet been implemented.
- Automatic editor preview is not currently implemented.
- The component has not yet been packaged as a formal Godot addon/plugin.

These are candidates for later versions.

---

# Planned Features

Possible future additions:

- Runtime text rebuilding
- Editor preview using `@tool`
- Ping-pong scrolling
- Per-character bounce
- Double sine waves
- Horizontal sine waves
- Circular text motion
- Character rotation waves
- Character scaling/pulsing
- Typewriter effect
- Flashing text
- Palette-based color cycling
- Custom color arrays
- Gradient movement across characters
- Pause points in scrolling text
- Scroll start delay
- Scroll restart delay
- Signals when text enters or leaves the viewport
- Loop counters
- Formal Godot addon packaging

---

# Godot Version

Designed for:

```text
Godot 4.x
```

Initially developed and tested as part of a Godot 4.7 workflow.

---

# Purpose

`TextController` is intended to be a reusable game-development component rather than a project-specific script.

The final goal is simple:

```text
Instance Scene
→ Enter Text
→ Choose Effects
→ Done
```

No additional scene construction should be required.

---

# Links:

- Main site: https://eddiesaunders.com/
- Code / tools: https://eddiesaunders.com/code
- YouTube: https://www.youtube.com/@onegridatatime

If you like the tool, use it in your own workflow, and want to support more small utilities, OGaaT content, and Eddie Saunders projects, you can optionally buy me a coffee here:

https://paypal.me/edwynsaunders1
