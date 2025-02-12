extends Sprite2D

var spent = false

func spend():
	spent = true
	self.modulate.a = 0.5

func unspend():
	spent = false
	self.modulate.a = 1


func hoverInformation():
	var info = {}
	
	return info

func getType():
	return "corpse"
