extends Node

onready var gui_node: Control = find_node("GUI")

enum { PLAYER_FIRING_BULLETS, PLAYER_BUILDING, PLAYER_DEAD }
var player_mode: int = PLAYER_FIRING_BULLETS
var player_score: int = 0

signal player_selection_state_changed(new_state)
signal player_hp_changed_sig(new_hp)
signal player_score_changed_sig(new_score)


func player_hp_changed(new_hp):
	self.emit_signal("player_hp_changed_sig", new_hp)

func player_score_changed(new_score):
	self.emit_signal("player_score_changed_sig", new_score)


func player_score_increase_by_amount(amount):
	player_score += amount
	self.emit_signal("player_score_changed_sig", player_score)


func _player_changed_mode(new_mode):
	player_mode = new_mode
	self.emit_signal("player_selection_state_changed", player_mode)
