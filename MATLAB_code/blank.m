obj = serial('COM3', 'BaudRate',9600)

fopen(obj)
fclose(obj)

%%
%Restart Serial port
%fclose(obj);
%fclose(obj);