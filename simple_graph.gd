extends Control



#Signals
signal update_all

#Arrays
var objects = []

var drag = .7
var speed = 2
var max_speed = 7
#For graph
var colliding = false

var graph_size = 100

var toadd = Vector2()
var offset = Vector2()
var global_pos = Vector2()

var dir = Vector2()

func read_world( file ):
	pass

func round_vector( vec ):
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
	OS.set_target_fps( 60 )
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input( true )
	set_fixed_process( true )

func _fixed_process(delta):
	if( Input.is_key_pressed( KEY_DOWN ) ): #Key down
		if( toadd.y < max_speed ):
			toadd.y += speed
	if( Input.is_key_pressed( KEY_UP ) ): #Key down
		if( toadd.y > -1*max_speed ):
			toadd.y -= speed
	if( Input.is_key_pressed( KEY_RIGHT ) ): #Key down
		if( toadd.x < max_speed ):
			toadd.x += speed
	if( Input.is_key_pressed( KEY_LEFT ) ): #Key down
		if( toadd.x > -1*max_speed ):
			toadd.x -= speed

	if( toadd.x < drag and toadd.x > drag*-1 ): #Stops the toadd x axis if within range of drag
		toadd.x = 0
	elif( toadd.x > 0 ): #Slows down toadd x axis if above or below zero
		toadd.x -= drag
	elif( toadd.x < 0 ):
		toadd.x += drag

	if( toadd.y < drag and toadd.y > drag*-1 ): #Stops the toadd y axis if within range of drag
		toadd.y = 0
	elif( toadd.y > 0 ): #Slows down toadd y axis if above or below zero
		toadd.y -= drag
	elif( toadd.y < 0 ):
		toadd.y += drag

	offset += toadd #Adds the offset
	toadd.y *= -1
	global_pos += toadd
	toadd.y *= -1

	if( offset.y > graph_size or offset.y < -1*graph_size ): #Resets the y axis offset
		offset.y = ( abs( offset.y ) - graph_size ) * negpos( offset.y ) #Carries on the offset

	if( offset.x > graph_size or offset.x < -1*graph_size ): #Resets the x axis offset
		offset.x = ( abs( offset.x ) - graph_size ) * negpos( offset.x ) #Carries on the offset

	update()

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
	draw_horizontal_graph( graph_size, offset.x, Color( 0, 0, 0 ) )
	draw_vertical_graph( graph_size, offset.y, Color( 0, 0, 0 ) )