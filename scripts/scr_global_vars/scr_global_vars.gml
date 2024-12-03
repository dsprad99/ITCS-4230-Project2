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

global.in_debug = false;

//LD Montello
//variable for setting the game to be paused.
global.paused = false;

//LD Montello
//the player's spawn point
//when we start the race.
//we need to reset this variable on
//room start.
global.player_start_slot = floor(random_range(1, 5));

//LD Montello
//select a random slot when the room starts,
//this is called in the room creation code.
function random_slot_on_room_start()
{
	show_message("HERE2");
	global.player_start_slot = floor(random_range(1, 5));
}

#endregion

#region mutables

#endregion


//Global functions

//LD Montello 
//Get all sequences in the game
//Here's where I found the base for this code:
//https://www.reddit.com/r/gamemaker/comments/j0f8eb/destroying_looping_sequences_how_to_get_sequence/
function get_all_sequences()
{
	//LD Montello
	//create a large enough array to store
	//our sequenecs
	var arr = array_create(10);
	
	//LD Montello
	//get all the elements on the sequences layer
	var elements = layer_get_all_elements("Sequences")
	//Loop through all the elements,
	//verify they are sequences,
	//and add them to the array.
	for (var i = 0; i < array_length(elements); i++)
	{
	    if layer_get_element_type(elements[i]) == layerelementtype_sequence
	    {
			array_push(arr, elements[i]);
	    }
	}
	
	//return the array.
	return arr;
}