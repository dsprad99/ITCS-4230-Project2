/// @description Insert description here
// You can write your code in this editor

if (has_popup)
{
	center_x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2
	center_y = camera_get_view_y(cam) + (64 * 5)
	layer_sequence_x(cur_popup, center_x)
	layer_sequence_y(cur_popup, center_y)
	
	//if the sequence is over destroy it and say
	//we are no longer in a sequence.
	if (layer_sequence_is_finished(cur_popup))
	{
		has_popup = false
		layer_sequence_destroy(cur_popup);
	}
}