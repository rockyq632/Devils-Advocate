extends Node2D

# This determines what player will collide with this boundary
@export var coll_layer:int = 8

@export var bounds:Dictionary[String,AnimatableBody2D]
@export var bound_shapes:Dictionary[String,CollisionShape2D]

const MAX_SPEED:int = 200
const COLL_BUFF_W:int = 50

var target_pos:Vector2 = Vector2.ZERO
var target_size:Vector2 = Vector2(640,360)

var curr_size:Vector2 = Vector2(640,360)


func _ready() -> void:
	# Set the proper collision layer for the boundary
	for i:String in bounds.keys():
		bounds[i].collision_layer = coll_layer
		bounds[i].collision_mask = coll_layer
	
	#move(Vector2(100,100))


func _physics_process(delta: float) -> void:
	# Ends process quickly if it doesn't need to run
	if(position == target_pos  and  curr_size == target_size): return
	
	##### HANDLING MOVEMENT #####
	# Set the direction
	internal_move(target_pos, delta)
	
	##### HANDLING SIZE #####
	#var x_dir:int=0
	#var y_dir:int=0
	#var new_w:int = curr_size.x
	#var new_h:int = curr_size.y
	'''
	if(curr_size.x > target_size.x): 
		x_dir=-1
		new_w = clampi( curr_size.x+((MAX_SPEED/2.0)*delta*x_dir), target_size.x-COLL_BUFF_W, curr_size.x+COLL_BUFF_W)
	elif(curr_size.x < target_size.x): 
		x_dir=1
		new_w = clampi( curr_size.x+((MAX_SPEED/2.0)*delta*x_dir), 0-COLL_BUFF_W, target_size.x+COLL_BUFF_W)
	if(curr_size.y > target_size.y): 
		y_dir=-1
		new_h = clampi( curr_size.y+((MAX_SPEED/2.0)*delta*y_dir), target_size.y-COLL_BUFF_W, curr_size.y+COLL_BUFF_W)
	elif(curr_size.y < target_size.y): 
		y_dir=1
		new_h = clampi( curr_size.y+((MAX_SPEED/2.0)*delta*y_dir), 0-COLL_BUFF_W, target_size.y+COLL_BUFF_W)
	'''
	
	internal_resize( target_size, delta )#Vector2(new_w, new_h) )


func move_and_resize(new_pos:Vector2, new_size:Vector2) -> void:
	move(new_pos)
	resize(new_size)


# Sets the target location to move boundary to
func move(new_pos:Vector2, justify:String="C") -> void:
	if( justify == "C" ):
		target_pos = new_pos

# Sets the new target size for the boundary
func resize(new_size:Vector2) -> void:
	target_size = new_size



func internal_move(new_pos:Vector2, delta:float) -> void:
	# North boundary movement
	var w:int = curr_size.x
	var h:int = curr_size.y
	var x_dir:int = 0
	var y_dir:int = 0
	if( 	bounds['N'].position.x < (new_pos.x+w+(2*COLL_BUFF_W))/2.0 ): x_dir=1
	
	elif( 	bounds['N'].position.x > (new_pos.x+w+(2*COLL_BUFF_W))/2.0 ): x_dir=-1
	if( bounds['N'].position.y < (h+(2*COLL_BUFF_W))/2.0 ): y_dir=1
	elif( bounds['N'].position.y > (h+(2*COLL_BUFF_W))/2.0 ): y_dir=-1
	#print(y_dir)
		
		
	bounds['N'].position.x += MAX_SPEED*x_dir*delta
	bounds['N'].position.y += MAX_SPEED*y_dir*delta


# Resizes so that the inner size is the same as new_size
func internal_resize(new_size:Vector2, _delta:float) -> void:
	var w:int = int(new_size.x)
	var h:int = int(new_size.y)
	
	bound_shapes['N'].shape.size.x = w+(4*COLL_BUFF_W)
	bound_shapes['S'].shape.size.x = bound_shapes['N'].shape.size.x
	bound_shapes['E'].shape.size.y = h+(4*COLL_BUFF_W)
	bound_shapes['W'].shape.size.y = bound_shapes['E'].shape.size.y
	
	'''
	bounds['N'].position.x = (w+(2*COLL_BUFF_W))/2.0
	bounds['S'].position.x = bounds['N'].position.x
	bounds['E'].position.x = w+COLL_BUFF_W
	
	bounds['S'].position.y = h+COLL_BUFF_W
	bounds['W'].position.y = (h+(2*COLL_BUFF_W))/2.0
	bounds['E'].position.y = bounds['W'].position.y
	'''
	
	#curr_size = new_size
	
	


# Removes the boundaries from the screen
func remove() -> void:
	bounds['N'].position= Vector2(320,-25)
	bounds['S'].position= Vector2(320,385)
	bounds['W'].position= Vector2(-25,180)
	bounds['E'].position= Vector2(665,180)
