extends Node

# This signal tells the UI to change the text
signal objective_updated(new_text)

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
