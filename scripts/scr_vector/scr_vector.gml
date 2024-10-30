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

//LD Montello
	//Constructor for Vector2 struct
	function Vector2(_x = 0, _y = 0) constructor
	{
	    x = _x;
	    y = _y;
		
		static Add = function(_vec2)
		{
			x += _vec2.x;
			y += _vec2.y;
		}
		
		
		//Where LD learned how to do 
		//JSdoc: https://www.reddit.com/r/gamemaker/comments/1gapo72/how_do_i_do_a_pretty_description_for_my_game/
		
		/**
		 * @function multiply_scalar
		 * @description Multiplies this vector by a scalar
		 * @param {Real} scalar to multiply this vector by.
		 * 
		 */
		multiply_scalar = function(scalar)
		{
			x *= scalar;
			y *= scalar;
			//Return self so that this
			//function can be used in inline math operations.
			return self;
		}
		
		
		
		//LD Montello
		//calc magnitude of the vector.
		//We use ignore so it doesn't
		//show up as an autocomplete when 
		//typing.
		///@description returns the magnitude/length of this vector.
		magnitude = function()
		{
			try {
				return sqrt(sqr(x) + sqr(y))
			}
			//if our sqrt returns not a real number,
			//then just return zero.
			catch (e)
			{
				return 0;
			}
		}
		
		/**
		 * @function normalized
		 * @description returns the vector with it's magnitude scaled to 1.
		 * @context
		 */
		normalized = function()
		{
			var normalized_vec = new Vector2();
			normalized_vec.x = x / magnitude();
			normalized_vec.y = y / magnitude();
			
			return normalized_vec;
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
		clamp_magnitude = function(_min, _max)
		{
			var temp_vec = self.normalized();
			if (self.magnitude() > _max)
				temp_vec = temp_vec.multiply_scalar(_max)
			else if (self.magnitude() < _max)
				temp_vec = temp_vec.multiply_scalar(_min)
		
			return temp_vec;
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
		static draw_vector2 = function(_vec2, size = 15, start_x = 0, start_y = 0)
		{
			draw_arrow(start_x, start_y, start_x + _vec2.x, start_y + _vec2.y, size);
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
		static draw_vector2_color = function(_vec2, size = 15, start_x = 0, start_y = 0, color = c_white)
		{
			//Store previous draw color.
			var prev_color = draw_get_color();
			//set to the desired draw color
			draw_set_color(color);
			//draw arrow
			draw_arrow(start_x, start_y, start_x + _vec2.x, start_y + _vec2.y, size);
			//set the draw color back to the original color.
			draw_set_color(prev_color);
		}
	}