extends StaticBody2D

const TYPE : String = "HealthPot"

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "Player":
		queue_free()	
		
