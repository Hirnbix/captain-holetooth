/// @DnDAction : YoYo Games.Audio.If_Audio_Playing
/// @DnDVersion : 1
/// @DnDHash : 4F6D308A
/// @DnDArgument : "soundid" "MainMenuMusic"
/// @DnDSaveInfo : "soundid" "MainMenuMusic"
var l4F6D308A_0 = MainMenuMusic;
if (audio_is_playing(l4F6D308A_0))
{

}

/// @DnDAction : YoYo Games.Audio.Stop_Audio
/// @DnDVersion : 1
/// @DnDHash : 05EE2A21
/// @DnDArgument : "soundid" "MainMenuMusic"
/// @DnDSaveInfo : "soundid" "MainMenuMusic"
audio_stop_sound(MainMenuMusic);

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 6C8CDB71
/// @DnDArgument : "soundid" "froglegs"
/// @DnDArgument : "loop" "1"
/// @DnDSaveInfo : "soundid" "froglegs"
audio_play_sound(froglegs, 0, 1, 1.0, undefined, 1.0);