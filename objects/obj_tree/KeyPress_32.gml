/// @description Insert description here
// You can write your code in this editor

with (obj_file) 
{
	
	if self.depth == layer_get_depth(layer_get_id("Leaves_drawn_below"))
	{
		//ds_list_add(other.lst_relative_vecs, [other.x - self.x, other.y - self.y]);
		show_debug_message([other.x - self.x, other.y - self.y]);
	}
}