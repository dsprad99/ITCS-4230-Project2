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
		
		
		
		//calc magnitude of the vector.
		get_magnitude = function()
		{
			return sqrt(sqr(x) + sqr(y))
		}
		
		//the actual magnitude variable
		//just gets the magnitude when
		//accessed.
		magnitude = get_magnitude();
		
		normalized = function()
		{
			var normalized_vec = new Vector2();
			normalized_vec.x = x / magnitude;
			normalized_vec.y = y / magnitude;
			
			return normalized_vec;
		}
		
		//LD Montello
		//Draw a given vector2.
		static draw_vector2 = function(_vec2, size = 15, start_x = 0, start_y = 0)
		{
			draw_arrow(start_x, start_y, start_x + _vec2.x, start_y + _vec2.y, size);
		}
		
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