# Game Design Document (GDD): \[Game Title\]

**Engine:** Godot Engine (v4.x recommended)

**Genre:** \[e.g., 2D Platformer, 3D Rogue-lite\]

**Target Platform:** \[PC, Mobile, Web, Console\]

**Status:** \[Concept / In Development / Prototype\]

---

## 1. Game Overview & Concept

* **Elevator Pitch:** *A 1-2 sentence hook describing your game.*
* **Core Loop:** *What does the player do second-to-second, minute-to-minute, and session-to-session? (e.g., Explore dungeon $\rightarrow$ Fight enemies $\rightarrow$ Collect loot $\rightarrow$ Upgrade stats).*
* **Unique Selling Proposition (USP):** *What makes this game stand out or feel different?*

---

## 3. Gameplay Mechanics & Controls

### Control Scheme

Which supported peripherals?

| Action | Keyboard / Mouse | Gamepad | Godot Input Map Name |
| :--- | :--- | :--- | :--- |
| **Move** | A / D or Arrow Keys | Left Stick | `move_left`, `move_right` |
| **Jump / Confirm** | Spacebar | Bottom Face Button (A/Cross) | `jump` |
| **Interact** | E | Right Face Button (X/Square) | `interact` |

### Character Controller (`CharacterBody2D` / `CharacterBody3D`)
* **Movement stats:** Speed, acceleration, friction, gravity, jump velocity.
* **Physics logic:** Mention if using `move_and_slide()` and how custom states (idle, run, jump, fall) are handled.

---

## 4. Art & Visual Style

* **Art Style:** \[e.g., Pixel Art 16x16, Low-Poly 3D, Hand-drawn vector\]
* **Godot Rendering Settings:** 
  * Renderer: **Forward+** (High-end 3D), **Mobile** (Optimized 3D), or **Compatibility** (WebGL/Low-end 2D/3D).
  * Lighting & Post-Processing: \[e.g., Use WorldEnvironment for Glow/SSAO, CanvasItem shaders for visual effects\].

---

## 5. Audio & Sound Design

* **Music:** Style, mood, and implementation (e.g., AudioStreamPlayer with interactive buses).
* **SFX:** Key sound effects needed (jump, hit, menu click, UI feedback).

---

## 6. Levels / World Design

* **Level Structure:** \[e.g., Linear progression, open-world, hub-based rooms\]
* **Godot Implementation Strategy:** 
  * Will levels be built using `TileMapLayer` (Godot 4) or modular 3D packed scenes?
  * How are transitions handled? (e.g., `SceneTree.change_scene_to_file()`, loading screens).

---

## 7. UI / UX Design

* **Menus:** Main Menu, Pause Menu, Game Over Screen, Settings.
* **Godot UI Nodes:** Use `Control` nodes with anchors, containers (`VBoxContainer`, `HBoxContainer`), and custom themes (`.tres` / `.theme`).

---

## 8. Milestone Roadmap

* [ ] **Prototype:** Core movement mechanics and basic physics working in Godot.
* [ ] **Vertical Slice:** One complete level with art, sound, UI, and win/loss states.
* [ ] **Content Alpha:** All core features implemented; bug fixing and balancing phase.
* [ ] **Beta / Polish:** Performance optimization, export templates testing for target platforms.