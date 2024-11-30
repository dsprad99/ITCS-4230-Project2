/// @description Insert description here
// You can write your code in this editor

//LD Montello
//if in debug, 
//draw the lerp speed
//scaled and the angle params.
if (global.in_debug)
draw_text(x, y, string(cur_lerp_speed_scaled) + ", " + string((cur_angle_max + abs(cur_angle_min)) ));