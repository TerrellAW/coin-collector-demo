extends Area2D


func _on_ready() -> void:
	set_monitoring(true)
	if is_monitoring():
		print("Monitoring is on")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("+1 coin collected!")
		Globals.coins += 1
		var prnt_coins = str(Globals.coins)
		print(prnt_coins + " coins collected.")
		queue_free() # Delete coin object
