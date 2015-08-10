% transform 
 function [lat, long] = inv_sinproj_tr(x,y) 
	R = 6371007.18100; %Earth's radius
	long_0 = 0;
	lat = y/R;
	long = long_0 + x/(R*cos(lat));

	lat = lat*180/pi; %degree
	long = long*180/pi;
 end 
