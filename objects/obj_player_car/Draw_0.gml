/// @description Insert description here
// You can write your code in this editor

draw_self()

//LD Montello
#region used to verify that vectors worked as expected.

//I draw tempVec twice
//so that I know for sure
//when calling tempVec.normalized()
//that tempVec isn't getting set to it's normalized
//value.
//var tempVec = new Vector2(50,50);
//Vector2.draw_vector2(tempVec, 15, x, y);

//var normalizedVec = tempVec.normalized();
//Vector2.draw_vector2(normalizedVec, 505, x, y);
//show_debug_message(string(normalizedVec.x) + ", " + string(normalizedVec.y));

//Vector2.draw_vector2_color(tempVec, 15, x, y, c_aqua);

//LD Montello
//we normalize the velocity vector so that it's magnitude
//is 1, this means when we multiply by a scalar we are
//essentially "setting" it's magnitude to that scalar value.
//while still maintaining the original direction.
//This is a concept known as "Vector Projection"
//We'll decide the length of the draw vector
//by multiplying our desired max length
//for the visual of the vector by the percentage
//for how close we are to the max speed.
var scaled_vec = vel_vec.normalized().multiply_scalar(100 * (vel_vec.magnitude() / max_speed));
//Draw the velocity vector
//so we can see how fast they
//are going.
Vector2.draw_vector2_color(scaled_vec, 15, x, y, c_yellow);
//show_debug_message(string(vel_vec.x) + ", " + string(vel_vec.y) + ", magnitude:" + string(vel_vec.magnitude()));


draw_text_transformed_color(x, y, image_angle, 5, 5, 0, c_black, c_black, c_black, c_black, 1);



#endregion