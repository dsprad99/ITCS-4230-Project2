/// @description Insert description here
// You can write your code in this editor

//LD Montello
//Recalculate center values.
center_x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) + camera_get_view_height(cam) / 2

//Set Bar position
x = center_x
y = center_y

//LD Montello
//Set the position of the resume button.
obj_resume_button.x = x - resume_button_x_relative
obj_resume_button.y = y - resume_button_y_relative

//LD Montello
//Set the position of the quit button
//to be relative to this object (the pause menu).
obj_quit_to_menu_button.x = x - quit_button_x_relative;
obj_quit_to_menu_button.y = y - quit_button_y_relative;