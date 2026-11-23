extends Node
## Machine à états globale du jeu (Autoload "GameManager").
## BOOT -> MENU -> LEVEL_SELECT -> PLAYING <-> PAUSED -> RESULTS

enum State { BOOT, MENU, LEVEL_SELECT, PLAYING, PAUSED, RESULTS }

## Transitions autorisées : toute autre demande est refusée.
const TRANSITIONS: Dictionary = {
	State.BOOT: [State.MENU],
	State.MENU: [State.LEVEL_SELECT],
	State.LEVEL_SELECT: [State.MENU, State.PLAYING],
	State.PLAYING: [State.PAUSED, State.RESULTS, State.MENU],
	State.PAUSED: [State.PLAYING, State.MENU],
	State.RESULTS: [State.MENU, State.LEVEL_SELECT, State.PLAYING],
}

var state: State = State.BOOT
var current_level_id: StringName = &""
var score: int = 0


func can_transition(to: State) -> bool:
	return to in (TRANSITIONS[state] as Array)


func change_state(to: State) -> bool:
	if not can_transition(to):
		push_warning(
			"GameManager: transition refusée %s -> %s" % [State.keys()[state], State.keys()[to]]
		)
		return false
	var previous: State = state
	state = to
	# Les nœuds de menu doivent avoir process_mode = ALWAYS pour rester actifs en pause.
	if is_inside_tree():
		get_tree().paused = (to == State.PAUSED)
	Events.game_state_changed.emit(previous, to)
	return true


func start_level(level_id: StringName) -> bool:
	if not change_state(State.PLAYING):
		return false
	current_level_id = level_id
	score = 0
	Events.level_started.emit(level_id)
	return true


func add_score(amount: int) -> void:
	score += amount
	Events.score_changed.emit(score)


func complete_level(stars: int) -> void:
	SaveManager.record_level_result(current_level_id, score, stars)
	SaveManager.save_game()
	if change_state(State.RESULTS):
		Events.level_completed.emit(current_level_id, score, stars)


func fail_level() -> void:
	if change_state(State.RESULTS):
		Events.level_failed.emit(current_level_id)
