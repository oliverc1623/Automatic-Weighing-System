classdef weight_sensor
    %WEIGHT_SENSOR Summary of this class goes here
    %   For connecting to the weight sensor then doing a buinc of things
    
    properties
        serialPort = [];
        
        readByte = 'r';
        tareByte = 't';
        
    end
    
    methods
        function obj = weight_sensor(portName)
            %WEIGHT_SENSOR Constructor class
            try
                % Open serial port
                obj.serialPort = serial(portName, 'BaudRate',9600);
                set(obj.serialPort,'BaudRate',9600);
                fopen(obj.serialPort);
                pause(3);
                
                % Try to send initialization byte
                display('Connected to sensor.');
            catch exc
                display('No connection with weight sensor');
                display('Subsequent calls to readsensor will return zero values');
                display(['Error message: ' exc.message]);
            end
        end
        
        function data = readWeight(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fwrite(obj.serialPort, obj.readByte)
            
            data = fscanf(obj.serialPort, '%e')   %// cast them to "uint8" if they are not already
            %Afloat = typecast( A , 'double')   %// cast the 4 bytes as a 32 bit float
            
            %data = fread(obj.serialPort,1,'double');
        end
        
        function closeSensor(obj)
            fclose(obj.serialPort);
        end
        
        function tareScale(obj)
            fwrite(obj.serialPort, obj.tareByte)
        end
        
        function setCalibrationFactor(obj, c)
            if c==5
                fwrite(obj.serialPort, 's')
            end
            if c==10
                fwrite(obj.serialPort, 'g')
            end
            if c==20
                fwrite(obj.serialPort, 'k')
            end
        end
    end
end

