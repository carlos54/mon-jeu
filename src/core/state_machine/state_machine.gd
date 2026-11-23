class_name StateMachine
extends Node
## Machine à états générique : ses enfants StateNode sont les états.
## Le nom du nœud (en minuscules) sert d'identifiant : "Idle" -> &"idle".

@export var initial_state: StateNode

var current: StateNode

var _states: Dictionary = {}


func _ready() -> void:
	for child: Node in get_children():
		if child is StateNode:
			var state: StateNode = child as StateNode
			_states[_key_of(state)] = state
			state.transition_requested.connect(transition_to)
	if initial_state != null:
		transition_to(_key_of(initial_state))


func transition_to(next_state: StringName, msg: Dictionary = {}) -> void:
	if not _states.has(next_state):
		push_warning("StateMachine: état inconnu '%s'" % next_state)
		return
	if current != null:
		current.exit()
	current = _states[next_state]
	current.enter(msg)


func _process(delta: float) -> void:
	if current != null:
		current.update(delta)


func _physics_process(delta: float) -> void:
	if current != null:
		current.physics_update(delta)


func _key_of(state: StateNode) -> StringName:
	return StringName(String(state.name).to_lower())
