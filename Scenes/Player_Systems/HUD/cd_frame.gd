extends PanelContainer

signal cooldown_finished

# Only used on Game Start
@export var ab_icon:Texture2D


func _ready() -> void:
	set_ab_icon(ab_icon)


# Set the ability icon image
func set_ab_icon(new_img:Texture2D) -> void:
	$S2D_AB_ICON.texture = new_img

# Sets the cooldown animation time
# Cooldown is 1 second long by default
func set_cooldown_time(_pc:PlayableCharacter ,ability:PC_Ability) -> void:
	$S2D_CD_Frame.speed_scale = 1/ability.ab_cd_time

# Returns the cooldown time in seconds
func get_cooldown_time() -> float:
	return (1/$S2D_CD_Frame.speed_scale)

# Play the cooldown animation
func play_cd() -> void:
	$S2D_CD_Frame.play("COOLDOWN")



# Called when the cooldown animation finishes
func _on_cd_animation_finished() -> void:
	cooldown_finished.emit()
