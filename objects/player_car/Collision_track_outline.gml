/// @description Insert description here
// You can write your code in this editor

//Davis Spradling
//This will act as the outline of our track and will make the 
//player stop for right now if going off
if (press_up) {
    car_speed -= (acceleration+2);
    if (car_speed < -max_speed){
		car_speed = -max_speed;  
	}
}

if (press_down) {
    car_speed += (acceleration+2);
    if (car_speed < max_speed){
		car_speed = max_speed;  
	}
}
