extends Node

var intro_monologue = false

var g1_dia_level = "introduction"
var g2_dia_level = "introduction"
var g3_dia_level = "introduction"

var level_clear_guard_1 = false
var level_clear_human_1 = false
var level_clear_angel_1 = false

var level_clear_guard_2 = false
var level_clear_human_2 = false
var level_clear_angel_2 = false


func clearLevel(level_name):
	match level_name:
		"guard_level_1":
			level_clear_guard_1 = true
			g1_dia_level = "guard_1"
			g2_dia_level = "none"
			g3_dia_level = "guard_1"
		"human_level_1":
			level_clear_human_1 = true
			g1_dia_level = "human_1"
			g2_dia_level = "none"
			g3_dia_level = "human_1"
		"angel_level_1":
			level_clear_angel_1 = true
			g1_dia_level = "angel_1"
			g2_dia_level = "none"
			g3_dia_level = "angel_1"
		
		"guard_level_2":
			level_clear_guard_2 = true
			g1_dia_level = "none"
			g2_dia_level = "none"
			g3_dia_level = "guard_2"
		"human_level_2":
			level_clear_human_2 = true
			g1_dia_level = "none"
			g2_dia_level = "none"
			g3_dia_level = "human_2"
		"angel_level_2":
			level_clear_angel_2 = true
			g1_dia_level = "none"
			g2_dia_level = "none"
			g3_dia_level = "angel_2"
	print(level_name)
		
