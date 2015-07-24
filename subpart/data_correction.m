function y = data_correction( x )

% our data correction -- ydata(8) is the EVI3@DOY_endpoint temporal interval 
%ydata(6) is the EVI3@DOY_startingpoint of temporal interval and ydata(7) is
%mean_EVI3??? Yes, That is right.
bad_index = find(x == 0);

if (size(bad_index,2) > 0)
m = -1;    
    for i= bad_index 
     if(m == i-1) 
       disp(['Data contains zeros']);         
       return;
     end    
     m = i;   
     x(i) = (x(i-1)+x(i+1))./2.0;
    end
end

y = x;