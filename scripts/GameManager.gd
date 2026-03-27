extends Node

# This signal tells the UI to change the text
signal objective_updated(new_text)

# Add this near your other signal at the top
signal interact_updated(is_visible: bool, text: String)

# Add this at the top with your other signals
signal lock_doors_event

# Add this at the bottom
func trigger_door_lock():
	lock_doors_event.emit()

# Add these functions at the bottom
func show_interact(text: String):
	interact_updated.emit(true, text)

func hide_interact():
	interact_updated.emit(false, "")

var keys_collected: int = 0
var total_keys: int = 2

# THIS IS THE FUNCTION THE ERROR IS COMPLAINING ABOUT
func update_objective(text: String):
	objective_updated.emit(text)

func add_key():
	keys_collected += 1
	if keys_collected < total_keys:
		update_objective("Find and Collect all keys (" + str(keys_collected) + "/" + str(total_keys) + ")")
	else:
		update_objective("Open the locked door and escape!")
