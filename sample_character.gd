tool
extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pos = Vector2( 400, 400 )
var rotd = 0.0
onready var world = get_node( "/root/main/world" )
onready var graph = get_node( "/root/main/world" )

func _ready():
	if( get_tree().is_editor_hint() ):
		move_to( pos )
	world.objects.append( get_node( "." ) )
	set_global_rotd( rotd ) #Set the global position and such
	move_to( pos )
	if( get_pos() == pos ): #Detect if unable to set the global position
		if( get_global_rotd() == rotd ):
			pass
		else:
			print( "Invalid rotation for ", get_name() )
			breakpoint
	else:
		print( "Invalid position for ", get_name() )
		breakpoint
	set_fixed_process( true )
	
func _fixed_process(delta):
	move( Vector2( delta*20, 0 ) )
	if( is_colliding() ):
		print( "Colliding" )
		graph.colliding = true
	else:
		graph.colliding = false

func on_update():
	move_to( Vector2( pos.x - world.global_pos.x, pos.y + world.global_pos.y ) )