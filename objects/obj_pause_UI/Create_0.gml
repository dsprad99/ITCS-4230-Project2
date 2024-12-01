/// @description Insert description here
// You can write your code in this editor

//LD Montello
//Get the camera
cam = view_get_camera(0);

//Calculate our center
//position relative to the camera.
center_x = camera_get_view_x(cam) //+ camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) //+ camera_get_view_height(cam) / 2


//LD Montello
//Store the relative offset of the resume
//button to this object so that we
//can use it in setting the position
//to always be relative to the pause menu.
//We position where we want the button on the pause
//menu in the room itself, and then on create
//it'll calculate the offset to be used to set 
//the position later.
resume_button_x_relative = x - obj_resume_button.x;
resume_button_y_relative = y - obj_resume_button.y;

//LD Montello,
//Do the same as the resume button with the only quit button in this room.
quit_button_x_relative = x - obj_quit_to_menu_button.x;
quit_button_y_relative = y - obj_quit_to_menu_button.y;

//LD Montello
//Deactivate ourselves
//when we're created.
//the pause menu should not be visible when we are activated.
instance_deactivate_object(self);