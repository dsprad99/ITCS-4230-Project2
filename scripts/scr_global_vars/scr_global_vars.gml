//LD Montello
//Set all global variables here.

#region constants

//LD Montello
//Declare global color variables
//use # because these are Hex colors.
global.neon_cyan = #5fffe4;
global.neon_magenta = #ff1493;
global.neon_lime = #a6fd29;


//LD Montello
//We need to make 2 different
//audio channels for music and SFX
//This will allow us to have 2
//different volume settings
//for the music and SFX.
//Here's where I learned how to do this:
//https://www.reddit.com/r/gamemaker/comments/kn14hb/how_to_lower_volume_of_all_sounds/
global.music_emitter = audio_emitter_create();
global.sfx_emitter = audio_emitter_create();

#endregion

#region mutables

#endregion