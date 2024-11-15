// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//LD Montello
//2D vectors so I can make math
//easier for myself, as I am used
//to unity having vectors built in to store
//positions and velocity.
//this will make storing momentum
//for our cars much easier.
//Here's where I got my start for this script:
//https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Overview/Structs.htm#:~:text=A%20struct%20is%20a%20variable,after%20it%20has%20been%20declared.
//And here's where a lot of the math comes from:
//https://manual.gamemaker.io/monthly/en/Additional_Information/Vectors.htm
function scr_vector(){
	
	
}

//create new global global.temp_vec
//global.temp_vec = new Vector2();

//LD Montello
	//Constructor for Vector2 struct
	function Vector2(_vec1) constructor
	{
		
		//Never access this ever,
		//but we use this to optimize making
		//new structs, so we set this one's
		//values in the below methods
		//instead of making a new one every time.
		//var global.temp_vec = new Vector2(0, 0);
		
		
		
		
	}
	
	
	function add(_vec1, _vec2)
	{
		var x1 = _vec1[0];
		var y1 = _vec1[1];
		var x2 = _vec2[0];
		var y2 = _vec2[1];
			
		return [x1 + x2, y1 + y2]
	}

		function subtract(_vec1, _vec2)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			var x2 = _vec2[0];
			var y2 = _vec2[1];
			
			return [x1 - x2, y1 - y2]
		}		
		
		//Where LD learned how to do 
		//JSdoc: https://www.reddit.com/r/gamemaker/comments/1gapo72/how_do_i_do_a_pretty_description_for_my_game/
		
		/**
		 * @function multiply_scalar
		 * @description Multiplies this vector by a scalar
		 * @param {Array} scalar to multiply this vector by.
		 * @param {Real} scalar to multiply this vector by.
		 * 
		 */
		function multiply_scalar(_vec1, scalar)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			return [x1 * scalar, y1 * scalar]
		}
		
		function multiply_vector(_vec1, _vec2)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			var x2 = _vec2[0];
			var y2 = _vec2[1];
			
			return [x1 * x2, y1 * y2]
		}
		
		function divide_scalar(_vec1, scalar)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			return [x1 / scalar, y1 / scalar]
		}
		
		
		
		//LD Montello
		//calc magnitude of the vector.
		//We use ignore so it doesn't
		//show up as an autocomplete when 
		//typing.
		///@description returns the magnitude/length of this vector.
		function magnitude(_vec1)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			//show_message(x1);
			
			return sqrt(sqr(x1) + sqr(y1))
			//try {
			//	return sqrt(sqr(x1) + sqr(y1))
			//}
			////if our sqrt returns not a real number,
			////then just return zero.
			//catch (e)
			//{
			//	return 0;
			//}
		}
		
		/**
		 * @function normalized
		 * @description returns the vector with it's magnitude scaled to 1.
		 * @context
		 */
		function normalized(_vec1)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			if (magnitude(_vec1) == 0)
			{
				return [0,0]
			}
			
			return [x1 / magnitude(_vec1), y1 / magnitude(_vec1)]
		}
		
		//LD Montello
		//Clamp magnitude of the vector
		
		/**
		 * @function clamp_magnitude
		 * @description returns the vector with it's magnitude clamped to the min and max values given.
		 * param {Real} min the minimum value the magnitude can be (inclusive).
		 * param {Real} max the maximum value the magnitude can be (inclusive).
		 * @context
		 */
		function clamp_magnitude(_vec1, _min, _max)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			
			try {
				//create a copy of ourself
				var temp = [x1, y1]
				if (magnitude(temp) > _max)
				{
					temp = normalized(temp);
					temp = multiply_scalar(temp, _max);
				}
				else if (magnitude(temp) < _min)
				{
					temp = normalized(temp);
					temp = multiply_scalar(temp, _min);
				}
				return temp;
			}
			catch (e)
			{
				return [x1, y1]//new Vector2(self.x, self.y);
			}
		}
		
		//Apparently you can't
		//make static non-anonymous functions.
		function angle_to_vector(_angle)
		{
			//For whatever reason
			//the way gamemaker handles
			//angle clamping we need to subtract 90.
			//_angle = -(_angle-90) mod 360;
			_angle = -_angle;
			
			//show_debug_log(_angle);
			//cos(radians) = x value
			//sin(radians) = y value
			//create vector pointing in direction.
			return [dcos(_angle), dsin(_angle)];
		}
		
		function vector_to_angle(_vec1)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			return point_direction(0, 0, x1, y1);
		}
		
		function set_angle(_vec1, _angle)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			
			//get the angle as a vector
			var temp = angle_to_vector(_angle);
			//set the new vector's magnitude
			//to be our old magnitude.
			//this will make it the same vector,
			//with a change in angle.
			temp = normalized(temp);
			temp = multiply_scalar(temp, magnitude(temp));
			
			//return the new rotated vector.
			return temp;
		}
		
		//same formula as calculating
		//magnitude, but this time we
		//can use two different vectors
		//to calculate distance.
		function distance(_vec1, _vec2)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			var x2 = _vec2[0];
			var y2 = _vec2[1];
			
			try {
				return sqrt(sqr(x1 - x2) + sqr(y1 - y2))
			}
			//if our sqrt returns not a real number,
			//then just return zero.
			catch (e)
			{
				return 0;
			}
		}
		
		//just return using gamemaker's 
		//dot function, it isn't complex anyway.
		function dot(_vec1, _vec2)
		{
			
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			var x2 = _vec2[0];
			var y2 = _vec2[1];
			
			return dot_product(x1, y1, x2, y2);
		}
		
		function left_perp(_vec1)
		{
			//global.temp_vec.x = self.y;
			//global.temp_vec.y = -self.x;
			
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			return [y1, -x1];
		}
		
		function right_perp(_vec1)
		{
			var x1 = _vec1[0];
			var y1 = _vec1[1];
			
			//var global.temp_vec = new Vector2(-self.y, self.x);
			//global.temp_vec.x = -self.y;
			//global.temp_vec.y = self.x;
			return [-y1, x1];
		}
		
		//LD Montello
		//
		
		/**
		 * @function draw_vector2
		 * @description Draw a given vector2. Use in Draw event or DrawGUI event.
		 * @param {Vector2} Vector to draw.
		 * @param {Real} Size of arrow head.
		 * @param {Real} x x position to draw vector at.
		 * @param {Real} y y position to draw vector at.
		 * @context
		 */
		function draw_vector2(_vec2, size = 15, start_x = 0, start_y = 0)
		{
			draw_arrow(start_x, start_y, start_x + _vec2[0], start_y + _vec2[1], size);
		}
		
		/**
		 * @function draw_vector2_color
		 * @description Draw a given vector2 with color. Use in Draw event or DrawGUI event.
		 * @param {Vector2} Vector to draw.
		 * @param {Real} Size of arrow head.
		 * @param {Real} x x position to draw vector at.
		 * @param {Real} y y position to draw vector at.
		 * @param {Color} Color to draw the origin of this vector at.
		 * @context
		 */
		function draw_vector2_color(_vec2, size = 15, start_x = 0, start_y = 0, color = c_white)
		{
			//Store previous draw color.
			var prev_color = draw_get_color();
			//set to the desired draw color
			draw_set_color(color);
			//draw arrow
			draw_arrow(start_x, start_y, start_x + _vec2[0], start_y + _vec2[1], size);
			//set the draw color back to the original color.
			draw_set_color(prev_color);
		}