classdef weight_sensor
    %WEIGHT_SENSOR Summary of this class goes here
    %   For connecting to the weight sensor then doing a buinc of things
    
    properties
        serialPort = [];
        
        readByte = 'r';
        tareByte = 't';
        cfByte = 'c';
        oneCFactorByte = 's';
        fiveCFactorByte = 'g';
        twnetyCFactorByte = 'k';
        
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
            fwrite(obj.serialPort, obj.readByte);
            
            data = fscanf(obj.serialPort, '%e');   %// cast them to "uint8" if they are not already
            %Afloat = typecast( A , 'double')   %// cast the 4 bytes as a 32 bit float
            
            %data = fread(obj.serialPort,1,'double');
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
            disp(fscanf(obj.serialPort, '%d', 14));
            %disp(params);
        end
       
        function setCalibrationFactor(obj, c)
            if c==1
                fwrite(obj.serialPort, obj.oneCFactorByte)
                disp('cf set to one')
            end
            if c==2
                fwrite(obj.serialPort, obj.fiveCFactorByte)
                disp('cf set to five')
            end
            if c==3
                fwrite(obj.serialPort, obj.twnetyCFactorByte)
                disp('cf set to twenty')
            end
        end
    end
end

