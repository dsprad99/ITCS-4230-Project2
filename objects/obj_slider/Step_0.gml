/// @description Handle Slider state
// You can write your code in this editor



//LD Montello
//We use 32 as our sprites
//are 32x32 pixels.
//Calculate the bounds of the 
//slider for checking if we are hovering.
left_bound = cur_x - slider_x_scale * 32 / 2
right_bound = cur_x + slider_x_scale * 32 / 2
up_bound = center_y - slider_y_scale * 32 / 2
lower_bound = center_y + slider_y_scale * 32 / 2 

//LD Montello
//Check if the mouse is hovering
//over the slider.
if (mouse_x >= left_bound and mouse_x <= right_bound and mouse_y >= up_bound and mouse_y <= lower_bound)
{
	is_hovering_slider = true;
}
else
{
	is_hovering_slider = false;
}

//LD Montello
//if we are hovering on the button
//and we click then say we are holding
//the slider.
if (is_hovering_slider == true and mouse_check_button(1))
{
	is_holding_slider = true;
}
//Even if the player's mouse moves
//off of the slider, if they are still
//holding the button down, let them
//continue to drag the slider.
else if (not  mouse_check_button(1))
{
	is_holding_slider = false;
}

//LD Montello
//Change color based
//on if we're hovering on
//or holding the slider.
if (is_holding_slider)
{
	slider_color = c_clicked;
}
else if (is_hovering_slider)
{
	slider_color = c_hover;
}
else
{
	slider_color = c_idle;
}

//LD Montello
//move the slider to follow
//the player x value
if (is_holding_slider)
{
	var position_on_slider = min_value;
	
	//Clamp position on slider to the 
	//left and right most positions
	if (mouse_x > (center_x + (slider_width / 2)))
	{
		position_on_slider = max_value;
	}
	else if (mouse_x < (center_x - (slider_width / 2)))
	{
		position_on_slider = min_value;
	}
	//otherwise, calculate where the mouse
	//is along the slider
	//and convert that to a 0-1 value
	//for setting the slider's current
	//value.
	//To find 0-1 value do : (mouse_x - (center_x - (slider_width / 2))) / slider_width
	//then multiply by max just incase max is larger than 1 so we
	//get the position relative to our range of values.
	else
	{
		position_on_slider = (max_value) * ((mouse_x - (center_x - (slider_width / 2))) / slider_width)
	}
	//set current value of the slider.
	set_cur_value(position_on_slider);
}
