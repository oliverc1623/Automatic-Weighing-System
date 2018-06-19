
data = zeros(1000, 1);

for i = 1:1000
    
    data(i) = m.readWeight;
    
    plot([1:i], data(1:i));
    pause(0.1);
    drawnow
    
end