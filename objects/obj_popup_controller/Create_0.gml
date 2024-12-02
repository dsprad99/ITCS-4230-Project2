/// @description Insert description here
// You can write your code in this editor


//LD Montello
//Get the camera
cam = view_get_camera(0);

//Calculate our center
//position relative to the camera.
center_x = camera_get_view_x(cam) //+ camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) //+ camera_get_view_height(cam) / 2

//the current popup
cur_popup = noone;

//do we currently have a popup?
has_popup = false;

function show_finish_popup()
{
	if (has_popup)
	{
		//kill the previous popup
		layer_sequence_destroy(cur_popup);
	}
	
	//create the traffic light for the start of the race.
	cur_popup = layer_sequence_create("Sequences", center_x, center_y, seq_finish);
	has_popup = true;
}

function show_checkpoint_popup()
{
	if (has_popup)
	{
		//kill the previous popup
		layer_sequence_destroy(cur_popup);
	}
	
	//create the checkpoint popup sequence.
	cur_popup = layer_sequence_create("Sequences", center_x, center_y, seq_checkpoint);
	has_popup = true;
}


function show_lap_1_popup()
{
	if (has_popup)
	{
		//kill the previous popup
		layer_sequence_destroy(cur_popup);
	}
	
	//create the lap sequence
	cur_popup = layer_sequence_create("Sequences", center_x, center_y, seq_lap1);
	has_popup = true;
}

function show_lap_2_popup()
{
	if (has_popup)
	{
		//kill the previous popup
		layer_sequence_destroy(cur_popup);
	}
	
	//create the lap sequence
	cur_popup = layer_sequence_create("Sequences", center_x, center_y, seq_lap2);
	has_popup = true;
}

function show_lap_3_popup()
{
	if (has_popup)
	{
		//kill the previous popup
		layer_sequence_destroy(cur_popup);
	}
	
	//create the lap sequence
	cur_popup = layer_sequence_create("Sequences", center_x, center_y, seq_lap3);
	has_popup = true;
}
