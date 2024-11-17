/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_path(track_path, 0, 0, true);

draw_vector2_color(multiply_scalar(normalized(heading_vec), 50), 15, x, y, c_yellow);

draw_vector2_color(multiply_scalar(normalized(left_perp_vec), left_dist), 15, path_point_x, path_point_y, c_green);
draw_vector2_color(multiply_scalar(normalized(right_perp_vec), right_dist), 15, path_point_x, path_point_y, c_blue);

draw_circle(x, y, separation_radius, true);

//draw the circle we must be inside
//of in order to calculate the next target point.
draw_circle_color(target_x, target_y, arrive_radius, c_red, c_red, true);

//Draw the normal vector of any objects we hit.
draw_vector2_color(multiply_scalar(normalized(normal), 100), 15, normal_x, normal_y, c_white);