extends Node

signal SlowPressed
signal NormalPressed
signal FastPressed


func _on_slow_button_pressed():
	SlowPressed.emit()


func _on_normal_button_pressed():
	NormalPressed.emit()


func _on_fast_button_pressed():
	FastPressed.emit()
