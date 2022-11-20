/// @DnDAction : YoYo Games.Gamepad.If_Gamepad_Button_Pressed
/// @DnDVersion : 1.1
/// @DnDHash : 67C66F80
/// @DnDArgument : "btn" "gp_face1"
var l67C66F80_0 = 0;
var l67C66F80_1 = gp_face1;
if(gamepad_is_connected(l67C66F80_0) && gamepad_button_check_pressed(l67C66F80_0, l67C66F80_1))
{
	/// @DnDAction : YoYo Games.Instances.Set_Sprite
	/// @DnDVersion : 1
	/// @DnDHash : 2FDD0DA3
	/// @DnDParent : 67C66F80
	/// @DnDArgument : "spriteind" "lochzahn_jump_up"
	/// @DnDSaveInfo : "spriteind" "lochzahn_jump_up"
	sprite_index = lochzahn_jump_up;
	image_index = 0;

	/// @DnDAction : YoYo Games.Movement.Jump_To_Point
	/// @DnDVersion : 1
	/// @DnDHash : 5DE60EA0
	/// @DnDParent : 67C66F80
	/// @DnDArgument : "y" "-15"
	/// @DnDArgument : "y_relative" "1"
	
	y += -15;
}

/// @DnDAction : YoYo Games.Gamepad.If_Gamepad_Button_Released
/// @DnDVersion : 1.1
/// @DnDHash : 38F94766
/// @DnDArgument : "btn" "gp_face1"
var l38F94766_0 = 0;
var l38F94766_1 = gp_face1;
if(gamepad_is_connected(l38F94766_0) && gamepad_button_check_released(l38F94766_0, l38F94766_1))
{
	/// @DnDAction : YoYo Games.Instances.Set_Sprite
	/// @DnDVersion : 1
	/// @DnDHash : 3FF11841
	/// @DnDParent : 38F94766
	/// @DnDArgument : "spriteind" "lochzahn_run"
	/// @DnDSaveInfo : "spriteind" "lochzahn_run"
	sprite_index = lochzahn_run;
	image_index = 0;

	/// @DnDAction : YoYo Games.Movement.Jump_To_Point
	/// @DnDVersion : 1
	/// @DnDHash : 4CF90B2E
	/// @DnDParent : 38F94766
	/// @DnDArgument : "y" "15"
	/// @DnDArgument : "y_relative" "1"
	
	y += 15;
}

/// @DnDAction : YoYo Games.Gamepad.If_Gamepad_Button_Pressed
/// @DnDVersion : 1.1
/// @DnDHash : 18F7B011
/// @DnDArgument : "btn" "gp_padl"
var l18F7B011_0 = 0;
var l18F7B011_1 = gp_padl;
if(gamepad_is_connected(l18F7B011_0) && gamepad_button_check_pressed(l18F7B011_0, l18F7B011_1))
{
	/// @DnDAction : YoYo Games.Instances.Set_Sprite
	/// @DnDVersion : 1
	/// @DnDHash : 4E4216B7
	/// @DnDParent : 18F7B011
	/// @DnDArgument : "spriteind" "lochzahn_run"
	/// @DnDSaveInfo : "spriteind" "lochzahn_run"
	sprite_index = lochzahn_run;
	image_index = 0;

	/// @DnDAction : YoYo Games.Movement.Jump_To_Point
	/// @DnDVersion : 1
	/// @DnDHash : 4BAA1EA2
	/// @DnDParent : 18F7B011
	/// @DnDArgument : "x" "-35"
	/// @DnDArgument : "x_relative" "1"
	x += -35;

	/// @DnDAction : YoYo Games.Instances.Sprite_Scale
	/// @DnDVersion : 1
	/// @DnDHash : 5C0F9766
	/// @DnDParent : 18F7B011
	/// @DnDArgument : "xscale" "-1"
	image_xscale = -1;
	image_yscale = 1;
}

/// @DnDAction : YoYo Games.Gamepad.If_Gamepad_Button_Pressed
/// @DnDVersion : 1.1
/// @DnDHash : 2B91A16D
/// @DnDArgument : "btn" "gp_padr"
var l2B91A16D_0 = 0;
var l2B91A16D_1 = gp_padr;
if(gamepad_is_connected(l2B91A16D_0) && gamepad_button_check_pressed(l2B91A16D_0, l2B91A16D_1))
{
	/// @DnDAction : YoYo Games.Instances.Set_Sprite
	/// @DnDVersion : 1
	/// @DnDHash : 252D801C
	/// @DnDParent : 2B91A16D
	/// @DnDArgument : "spriteind" "lochzahn_run"
	/// @DnDSaveInfo : "spriteind" "lochzahn_run"
	sprite_index = lochzahn_run;
	image_index = 0;

	/// @DnDAction : YoYo Games.Movement.Jump_To_Point
	/// @DnDVersion : 1
	/// @DnDHash : 73B13532
	/// @DnDParent : 2B91A16D
	/// @DnDArgument : "x" "35"
	/// @DnDArgument : "x_relative" "1"
	x += 35;
}