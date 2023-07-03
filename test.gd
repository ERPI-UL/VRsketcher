extends Button

var c = 0

func h() -> void :
	print("hover")

func p() -> void :
	c += 1
	text = str(c)
	print("pressed")
