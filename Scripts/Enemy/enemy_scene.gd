extends Control

@onready var enemy_hp = $N_Enemy.curr_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$C_Enemy_Health_Bar.set_max_hp( $N_Enemy.max_hp )
	$C_Enemy_Health_Bar.set_hp( $N_Enemy.curr_hp )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$C_Enemy_Health_Bar.set_hp( $N_Enemy.curr_hp )
	enemy_hp = $N_Enemy.curr_hp
