/// @description Start Race
// You can write your code in this editor

//when the start light
//sequence broadcasts this message
//the race will start.

//Where LD Learned how to read this data:
//https://manual.gamemaker.io/beta/en/The_Asset_Editors/Sequence_Properties/Broadcast_Messages.htm#:~:text=These%20messages%20are%20simple%20strings,instances%20that%20listen%20for%20it.
if event_data[? "event_type"] == "sequence event" // or you can check "sprite event"
{
    switch (event_data[? "message"])
    {
		//if the message we 
		//recieved is the Race Start
		//message, then let's start it.
        case "Race Start":
			start_time = current_time;
			start_race();
        break;
    }
}
