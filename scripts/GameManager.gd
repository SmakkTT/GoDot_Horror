extends Node


signal objective_updated(new_text) # Besked til UI om at opdatere spillerens opgave/mission
signal interact_updated(is_visible: bool, text: String) # Besked til UI om at vise eller skjule "Tryk på..." teksten
signal lock_doors_event # Besked til alle døre i spillet om at de skal låse

func trigger_door_lock(): # Kører signalet, der fortæller dørene at de skal låse
	lock_doors_event.emit()

# Viser interager-teksten på skærmen
func show_interact(text: String):
	interact_updated.emit(true, text)

# Skjuler interager-teksten igen
func hide_interact():
	interact_updated.emit(false, "")


var keys_collected: int = 0 # Holder styr på, hvor mange nøgler spilleren har samlet op
var total_keys: int = 2 # Hvor mange nøgler der skal bruges i alt for at vinde

# Opdaterer teksten for spillerens nuværende opgave på skærmen
func update_objective(text: String):
	objective_updated.emit(text)


func add_key(): # Denne funktion kører, hver gang spilleren samler en nøgle op
	keys_collected += 1
	if keys_collected < total_keys: # Hvis vi stadig mangler at finde nogle nøgler
		update_objective("Find and Collect all keys (" + str(keys_collected) + "/" + str(total_keys) + ")")
	else: # Hvis vi har fundet alle nøglerne
		update_objective("Open the locked door and escape!")
