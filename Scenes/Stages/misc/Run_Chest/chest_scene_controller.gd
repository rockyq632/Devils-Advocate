class_name ChestScene
extends Control

signal chest_items_distributed


@export var excluded_items:Array[ITEM_REF.KEY] = [ITEM_REF.KEY.NONE]
@export var num_items:int = 5

@export_subgroup("UI")
@export var anim_player:AnimationPlayer
@export var chest_menu:ChestMenu

@export_subgroup("READ ONLY")
@export var contents:Array[Item] = []
@export var contents_ids:Array[int] = []
@export var is_chest_opened:bool = false

var cnt_coll:int = 0




func _ready() -> void:
	# Generate contents of chest
	while(contents.size() != num_items):
		var r:int = randi_range(0, (ITEM_REF.KEY.size()-1))
		
		if( r in excluded_items ):
			continue
		else:
			contents.append( load(ITEM_REF.dict[r]).instantiate() )
			contents_ids.append( r )
	
	# Make menu aware of items
	chest_menu.create_menu(contents)
	
	# Connect menu signals
	chest_menu.item_selected.connect(_on_item_selected)
	chest_menu.item_skipped.connect(_on_item_skipped)


func _process(_delta: float) -> void:
	if( Input.is_action_pressed("ACTION1") and (not is_chest_opened) and cnt_coll>0):
		open_chest()
		is_chest_opened = true


func open_chest() -> void:
	print("chest opened")
	anim_player.play("SHOW_CHEST_MENU")


func _on_chest_interact_range_entered(_body: Node2D) -> void:
	cnt_coll += 1
	anim_player.play("SHOW_TOOLTIP")

func _on_chest_interact_range_exited(_body: Node2D) -> void:
	cnt_coll -= 1
	if(cnt_coll == 0):
		anim_player.play("HIDE_TOOLTIP")


func _on_item_selected(_id:int, _selection:Item) -> void:
	anim_player.play("HIDE_CHEST_MENU")
	chest_items_distributed.emit()
func _on_item_skipped(_id:int) -> void:
	anim_player.play("HIDE_CHEST_MENU")
	chest_items_distributed.emit()
