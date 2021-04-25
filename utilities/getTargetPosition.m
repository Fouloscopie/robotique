function [x_target,y_target] = getTargetPosition()

ok = 0 ;

while ok==0
    x_target = rand.*2.8 - 1.4 ;
    y_target = rand.*1.6 - 0.8 ;
    
    if abs(x_target)>0.5 || abs(y_target)>0.4
        ok = 1 ;
    end
    
end
    
    
    
    
end

