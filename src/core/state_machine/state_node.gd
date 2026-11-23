class_name StateNode
extends Node
## État de base d'une machine à états d'entité (joueur, ennemi...).
## Héritez et surchargez enter/exit/update/physics_update.
## Demandez un changement d'état avec : transition_requested.emit(&"move")

signal transition_requested(next_state: StringName, msg: Dictionary)


func enter(_msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
