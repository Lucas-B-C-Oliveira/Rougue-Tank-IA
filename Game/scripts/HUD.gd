extends CanvasLayer


func _ready():
	GAME_MANAGER.connect("score_changed", self , "on_score_changed")
	write_score()
	
func on_score_changed():
	write_score()

func write_score():
	$score.text = str(GAME_MANAGER.score)