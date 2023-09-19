extends Node2D

var next_cycle
var cycle_time
var facing: Direction
var head: Node2D
var running
var bodySize
var heartTemplate
var bodySegments: Array
var bodyTemplate
var hearts: Array
var spawnArea
var score
var scoreLabel: Label
var start_screen: Node2D

enum Direction { Left, Right, Up, Down }

func _ready():
	head = find_child("Head")
	heartTemplate = preload("res://Heart.tscn")
	bodyTemplate = preload("res://Body.tscn")
	spawnArea = find_child("Area")
	scoreLabel = find_child("Score Label")
	start_screen = find_child("Start Screen")
	running = false
	randomize()
	
func reset():
	cycle_time = get_meta("CycleTime")
	next_cycle = Time.get_ticks_msec() + cycle_time
	facing = Direction.Right
	running = true
	bodySize = 0
	score = 0
	head.position = Vector2(228, 228)
	for item in bodySegments:
		item.queue_free()
	for item in hearts:
		item.queue_free()
	bodySegments.clear()
	hearts.clear()
	add_heart()	

func _physics_process(_delta):
	if !running: return
	
	if facing == Direction.Left: head.rotation_degrees = 180
	elif facing == Direction.Right: head.rotation_degrees = 0
	elif facing == Direction.Up: head.rotation_degrees = 270
	else: head.rotation_degrees = 90

	if Time.get_ticks_msec() >= next_cycle:
		next_cycle += cycle_time
		score += bodySize + 1
		scoreLabel.text = "Score: " + str(score)
		
		var newBody = add_body()
		if facing == Direction.Left: head.position.x -= 24
		elif facing == Direction.Right: head.position.x += 24
		elif facing == Direction.Up: head.position.y -= 24
		else: head.position.y += 24
		spawnArea.add_child(newBody)
		
		while bodySegments.size() > bodySize:
			var b = bodySegments.pop_front()
			b.queue_free()
		

func _input(event):
	if event.is_action_pressed("Left"): facing = Direction.Left
	elif event.is_action_pressed("Right"): facing = Direction.Right
	elif event.is_action_pressed("Up"): facing = Direction.Up
	elif event.is_action_pressed("Down"): facing = Direction.Down

func _on_head_area_entered(area):
	if(area.visibility_layer == 2):
		bodySize += 1
		area.queue_free()
		var index = hearts.find(area)
		hearts.remove_at(index)

		if hearts.size() == 0: call_deferred("add_heart")
		return
	call_deferred("game_over")
	
func add_heart():
	var heart = heartTemplate.instantiate()
	heart.position = Vector2(12, 12)
	var x = randi_range(0, 20)
	var y = randi_range(0, 20)
	heart.position += Vector2(24 * x, 24 * y)
	spawnArea.add_child(heart)
	hearts.append(heart)
	
func add_body():
	var body = bodyTemplate.instantiate()
	body.position = head.position
	bodySegments.push_back(body)
	return body

func _on_start_screen_fast_pressed():
	set_meta("CycleTime", 350)
	start_game()

func _on_start_screen_normal_pressed():
	set_meta("CycleTime", 500)
	start_game()

func _on_start_screen_slow_pressed():
	set_meta("CycleTime", 750)
	start_game()

func start_game():
	reset()
	start_screen.visible = false
	
func game_over():
	running = false
	start_screen.visible = true

