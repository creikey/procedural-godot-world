extends Control

#Signals
signal update_all

#Arrays
var objects = []

#Keycodes
var keycodes = [ KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT ]

#For graph
var colliding = false
var leftinput = false
var rightinput = false
var upinput = false
var downinput = false
var max_speed = 8
var speed_up = 0.2
var slow_down = 0.5
var toadd = Vector2()

var graph_size = 100

var store = Vector2()
var offset = Vector2()
var global_pos = Vector2()

var dir = Vector2()

func round_vector( vec ): #Rounds a vector
	return Vector2( round( vec.x ), round( vec.y ) )

func negpos( num ): #Gets the sign of a number
	"""Gets the sign of a number"""
	if( num < 0 ):
		return -1
	elif( num > 0 ):
		return 1
	else:
		return 0

func connect_all( list, sig, funcname ): #Connects all of the nodes to a function in a list
	for node in list:
		if( is_connected( sig, node, funcname ) ):
			pass
		else:
			print( "connecting ", node )
			connect( sig, node, funcname )

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input( true )
	set_fixed_process( true )

func _fixed_process(delta):
	if( Input.is_key_pressed( KEY_DOWN ) ): #Key down
		if( toadd.y < max_speed ):
			toadd.y += speed_up
		downinput = true
	if( Input.is_key_pressed( KEY_UP ) ): #Key down
		if( toadd.y > -1*max_speed ):
			toadd.y -= speed_up
		upinput = true
	if( Input.is_key_pressed( KEY_RIGHT ) ): #Key down
		if( toadd.x < max_speed ):
			toadd.x += speed_up
		rightinput = true
	if( Input.is_key_pressed( KEY_LEFT ) ): #Key down
		if( toadd.x > -1*max_speed ):
			toadd.x -= speed_up
		leftinput = true
	if( Input.is_key_pressed( KEY_Q ) ):
		toadd.x = 10
		rightinput = true
	
	if( toadd.y >= slow_down and downinput == false ): #Slows down the y axis
		toadd.y -= slow_down
	elif( toadd.y <= -1*slow_down and upinput == false ):
		toadd.y += slow_down
	elif( downinput == false and upinput == false ):
		toadd.y = 0
	if( toadd.x >= slow_down and rightinput == false ): #Slows down the x axis
		toadd.x -= slow_down
	elif( toadd.x <= -1*slow_down and leftinput == false ):
		toadd.x += slow_down
	elif( rightinput == false and leftinput == false ):
		toadd.x = 0

	
	if( offset.y > graph_size or offset.y < -1*graph_size ): #Resets the y axis offset
		offset.y = ( abs( offset.y ) - graph_size ) * negpos( offset.y ) #Carries on the offset
	elif( colliding == false ):
		offset.y += toadd.y
		global_pos.y -= toadd.y
	else:
		print( "colliding on the y axis" )
	if( offset.x > graph_size or offset.x < -1*graph_size ): #Resets the x axis offset
		offset.x = ( abs( offset.x ) - graph_size ) * negpos( offset.x ) #Carries on the offset
	elif( colliding == false ):
		offset.x += toadd.x
		global_pos.x += toadd.x
	else:
		print( "colliding on the y axis" )

	if( leftinput == true or rightinput == true or upinput == true or downinput == true ):
		update()
	leftinput = false
	rightinput = false
	upinput = false
	downinput = false

func draw_horizontal_graph( size, offset, color ):
	var counter = 0
	while( counter < 2000/size ):
		draw_line( Vector2( counter*size - offset, 0 ), Vector2( counter*size - offset, OS.get_window_size().y ), color )
		counter += 1

func draw_vertical_graph( size, offset, color ):
	var counter = 0
	while( counter < 2000/size ):
		draw_line( Vector2( 0, counter*size - offset ), Vector2( OS.get_window_size().x, counter*size - offset ), color )
		counter += 1

func _draw():
	connect_all( objects, "update_all", "on_update" )
	emit_signal( "update_all" )
	offset = round_vector( offset )
	draw_horizontal_graph( graph_size, offset.x, Color( 0, 0, 0 ) )
	draw_vertical_graph( graph_size, offset.y, Color( 0, 0, 0 ) )
