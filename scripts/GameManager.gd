extends Node

# Besked til UI om at opdatere spillerens opgave/mission
signal objective_updated(new_text)

# Besked til UI om at vise eller skjule "Tryk på..." teksten
signal interact_updated(is_visible: bool, text: String)

# Besked til alle døre i spillet om at de skal låse
signal lock_doors_event

# Kører signalet, der fortæller dørene at de skal låse
func trigger_door_lock():
	lock_doors_event.emit()

# Viser interager-teksten på skærmen
func show_interact(text: String):
	interact_updated.emit(true, text)

# Skjuler interager-teksten igen
func hide_interact():
	interact_updated.emit(false, "")

# Holder styr på, hvor mange nøgler spilleren har samlet op
var keys_collected: int = 0
# Hvor mange nøgler der skal bruges i alt for at vinde
var total_keys: int = 2

# Opdaterer teksten for spillerens nuværende opgave på skærmen
func update_objective(text: String):
	objective_updated.emit(text)

# Denne funktion kører, hver gang spilleren samler en nøgle op
func add_key():
	keys_collected += 1
	
	# Hvis vi stadig mangler at finde nogle nøgler
	if keys_collected < total_keys:
		update_objective("Find and Collect all keys (" + str(keys_collected) + "/" + str(total_keys) + ")")
	# Hvis vi har fundet alle nøglerne
	else:
		update_objective("Open the locked door and escape!")
