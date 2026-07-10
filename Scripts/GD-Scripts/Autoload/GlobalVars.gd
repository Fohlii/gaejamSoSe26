extends Node

var musicVol: int = 100
var sfxVol: int =100
var player_won = false
var DEBUG_PLAYERMOVEMENT: bool = false
var spawnpointPresent: Vector2 = Vector2(600, -10400)
var spawnpointPast: Vector2 = Vector2(600, 10400)
signal winning_condition
var player_in_past = false
signal esc_pressed
