/// @description Set camera pos
// You can write your code in this editor

//LD Montello
//only set cam position
//if it has a target.
if (instance_exists(cam_target))
{
//LD Montello
//at the end of each step
//Set the camera position
//to be centered on the position.
//This fixes the jittering that
//the built in camera follow had.
camera_set_view_pos(cam, cam_target.vel_vec[0] + cam_target.x - camera_get_view_width(cam) / 2, cam_target.vel_vec[1] +  cam_target.y - camera_get_view_height(cam) / 2)
}


//LD Montello
//clamp the x of the camera to 
//the edges of the room
var clamp_x = clamp(camera_get_view_x(cam), 0,  room_width - camera_get_view_width(cam))
//LD Montello
//clamp the y of the camera to
//the edges of the room
var clamp_y = clamp(camera_get_view_y(cam), 0,  room_height - camera_get_view_height(cam))

camera_set_view_pos(cam, clamp_x, clamp_y)