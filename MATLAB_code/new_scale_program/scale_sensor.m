classdef scale_sensor
     properties
        serialPort = [];
        
        readByte = 'r';
        tareByte = 't';
        cfByte = 'c';
     end
     methods
        function obj = scale_sensor(portName)
            %WEIGHT_SENSOR Constructor class
            try
                % Open serial port
                obj.serialPort = serial(portName, 'BaudRate',9600);
                set(obj.serialPort,'BaudRate',9600);
                fopen(obj.serialPort);
                pause(0.5);
                
                % Try to send initialization byte
                disp('Connected to sensor.');
            catch exc
                disp('No connection with weight sensor');
                disp('Subsequent calls to readsensor will return zero values');
                display(['Error message: ' exc.message]);
            end
        end
        function data = readWeight(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fwrite(obj.serialPort, obj.readByte);            
            data = fscanf(obj.serialPort, '%g');   %// cast them to "uint8" if they are not already
            %disp(data);
            %Afloat = typecast( A , 'double')   %// cast the 4 bytes as a 32 bit float
            %data = fread(obj.serialPort,2, 'double');
        end
        function closeSensor(obj)
            fclose(obj.serialPort);
            delete(instrfindall);
        end  
        function tareScale(obj)
            fwrite(obj.serialPort, obj.tareByte);
        end
        function sensor1SetCfactor(obj, value)
            %params = ['c','a'];
            %fwrite(obj.serialPort, ['s', sprintf('%3.8d', 678)]);
            fwrite(obj.serialPort, 's');
            fwrite(obj.serialPort, value);
            pause(1);
            %disp(fscanf(obj.serialPort, '%d', 14));
            %disp(params);
        end
    end
end

