/// @description Insert description here
// You can write your code in this editor

center_x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) + (64 * 5)
layer_sequence_x(light_drop_down_start, center_x)
layer_sequence_y(light_drop_down_start, center_y)