function y = value_correction( x )

bad_index = find(x == 0);

if (size(bad_index,2) > 0)
m = -1;    
    for i= bad_index 
     if(m == i-1) 
       disp(['X contains only zeros']);         
       return;
     end    
     m = i;   
     x(i) = (x(i-1)+x(i+1))./2.0; %calculate mean value and then replace bad_index value on mean
    end
end

y = x;