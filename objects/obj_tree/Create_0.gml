/// @description Insert description here
// You can write your code in this editor

image_xscale = 5;
image_yscale = 5;

//LD Montello
//Array for relative coordinates
//of obj_file objects
//that need to be spawned
//on "Leaves_drawn_above"
//layer
arr_obj_files_above = [
[ 283,9 ],
[ -277,4 ],
]

//LD Montello
//spawn the normal sized files
//on the above layer.
for (var i = 0; i < array_length(arr_obj_files_above); i++)
{
	instance_create_layer(x - arr_obj_files_above[i][0], y - arr_obj_files_above[i][1], "Leaves_drawn_above", obj_file)
}

//LD Montello
//Array for relative coordinates
//of obj_file_small objects
//that need to be spawned
//on "Leaves_drawn_above"
//layer
arr_obj_files_small_above = [
[ -177,-81 ],
[ 138,-21 ],
]

//LD Montello
//spawn the small sized files
//on the above layer
for (var i = 0; i < array_length(arr_obj_files_small_above); i++)
{
	instance_create_layer(x - arr_obj_files_small_above[i][0], y - arr_obj_files_small_above[i][1], "Leaves_drawn_above", obj_file_small)
}

//LD Montello
//Array for relative coordinates
//of obj_file objects
//that need to be spawned
//on "Leaves_drawn_below"
//layer
arr_obj_files_below = [
[ -267,274 ]
]

//LD Montello
//spawn the normal sized files
//on the below layer.
for (var i = 0; i < array_length(arr_obj_files_below); i++)
{
	instance_create_layer(x - arr_obj_files_below[i][0], y - arr_obj_files_below[i][1], "Leaves_drawn_below", obj_file)
}

//LD Montello
//Array for relative coordinates
//of obj_file_small objects
//that need to be spawned
//on "Leaves_drawn_below"
//layer
arr_obj_files_small_below = [
[ -307,134 ],
[ -187,289 ],
[ -122,249 ],
[ 3,239 ],
[ 108,214 ],
[ 278,169 ],
[ 178,29 ],
[ 213,9 ],
[ -122,89 ],
[ 103,89 ],
[ 83,-51 ],
]

//LD Montello
//spawn the small sized files
//on the below layer.
for (var i = 0; i < array_length(arr_obj_files_small_below); i++)
{
	instance_create_layer(x - arr_obj_files_small_below[i][0], y - arr_obj_files_small_below[i][1], "Leaves_drawn_below", obj_file_small)
}