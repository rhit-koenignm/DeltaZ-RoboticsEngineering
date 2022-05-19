classdef TicTacToe < hgsetget
    %PLATELOADER Controls the Beckman Coulter Plate Loader Robot
    %   Performs the basic actions to control the plate loader
    
    properties
        gameBoard
        gameState
    end
    properties (Constant = true)
    end
    
    methods
        function obj = TicTacToe()
            fprintf('Connecting to robot...');
            portStr = sprintf('COM%d',portNumber);
            obj.serialRobot = serialport(portStr, 19200, "Timeout", 15);

            writeline(obj.serialRobot,'INITIALIZE');
            response = readline(obj.serialRobot);
            % Had to print the response since a construct cannot return mulitple items
            fprintf(response);  
            obj.xAxisPosition = 3;
            obj.isZAxisExtended = false;
            obj.isGripperClosed = true;
            % TODO: When turned on there might be a plate present
            %   If you want, you could use the GRIPPER_STATUS command and
            %   read the string reply to set the plate status if needed.
            obj.isPlatePresent = false;
        end
        
        function response = placeMark(obj, mark, pos)
            % Reset robot
            writeline(obj.serialRobot,'RESET');
            
            response = readline(obj.serialRobot);
            
        end
        function response = x(obj,pos)
            % Moves the x-axis to position, passes the reply back to caller
            if (pos <1 || pos>5)
                fprintf('Illegal position');
                return
            end
            xCommand = sprintf('X-AXIS %d',pos);
            writeline(obj.serialRobot,xCommand);
            if(obj.xAxisPosition ~= pos)
                obj.isZAxisExtended = false;
            end
            obj.xAxisPosition = pos;
            response = readline(obj.serialRobot);
        end
        function response = extend(obj)
            % Extends the Z-Axis, passes the reply back to caller
            writeline(obj.serialRobot,'Z-AXIS EXTEND');
            response = readline(obj.serialRobot);
            if(contains(response,'ERROR'))
                obj.isZAxisExtended = false;
            else
                obj.isZAxisExtended = true;
            end
        end
        function response = retract(obj)
            % Retracts the Z-Axis, passes the reply back to caller
            writeline(obj.serialRobot,'Z-AXIS RETRACT');
            obj.isZAxisExtended = false;
            response = readline(obj.serialRobot);
        end
        function response = close(obj)
            % Close Gripper, passes the reply back to caller
            writeline(obj.serialRobot,'GRIPPER CLOSE');
            obj.isGripperClosed = true;
            response = readline(obj.serialRobot);
            if( contains(response,'NOPLATE'))
                obj.isPlatePresent = false;
            else
                obj.isPlatePresent = true;
            end
        end
        function response = open(obj)
            % Open Gripper, passes the reply back to caller
            writeline(obj.serialRobot,'GRIPPER OPEN');
            obj.isGripperClosed = false;
            obj.isPlatePresent = false;
            response = readline(obj.serialRobot);
        end
        function response = movePlate(obj, startPos, endPos)
            % movePlate(startPos, endPos)- Passes two MATLAB numbers for the
            % start and end position of the plate, tries to move the plate to
            % that position, and passes the reply back to caller
            if (startPos <1 || startPos>5 || endPos <1 || endPos>5)
                fprintf('Illegal position');
                return
            end
            moveCommand = sprintf('MOVE %d %d',startPos,endPos);
            writeline(obj.serialRobot,moveCommand);

            response = readline(obj.serialRobot);
            if( contains(response,'ERROR'))
                obj.xAxisPosition = startPos;
                obj.isZAxisExtended = false;
                obj.isGripperClosed = false;
                obj.isPlatePresent = false;
            else
                obj.xAxisPosition = 3;
                obj.isZAxisExtended = false;
                obj.isGripperClosed = true;
                obj.isPlatePresent = false;
            end
            
        end
        function response = setTimeValues(obj,timeDelays)
            % setTimeValues(timeDelays) - Passes a matrix with 5 rows (froms)
            % and 5 columns (tos) to set all the time delay value
            if (size(timeDelays) ~= [5 5])
                fprintf('Need a 5 by 5 matrix of time delays');
                return
            end
            for i = 1:5
                for j = 2:4
                    if(i ~= j)
                        timeCommand = sprintf('SET_DELAY %d %d %d', i,j,timeDelays(i,j));
                        writeline(obj.serialRobot,timeCommand);
                        response = readline(obj.serialRobot);
                        fprintf(response);
                    end
                end
            end
        end
        function response = resetDefaultTimes(obj)
            % Resets the default time delay table values
            response = obj.setTimeValues(obj.defaultTimeTable);
        end
        function response = getStatus(obj)
            % Since we are keeping the status as instance fields we can just
            % get the properties of the class, this is a useful double check
            writeline(obj.serialRobot,'LOADER_STATUS');
            response = readline(obj.serialRobot);
            % TODO: Make the values update if different
            %  Can someone make the call to LOADED_STATUS also update
            %  properties, just in case somehow it gets off
        end
        
        function [xPos,zAxis,grip,plate] = getProperties(obj)
            % Returns the status properties of the robot (for GUI display)
            xPos = obj.xAxisPosition;
            zAxis = obj.isZAxisExtended;
            grip = obj.isGripperClosed;
            plate = obj.isPlatePresent;
        end
        
        function disp(obj)
            fprintf('  X-AXIS %d, ',obj.xAxisPosition);
            if (obj.isZAxisExtended)
                fprintf('EXTENDED, ');
            else
                fprintf('RETRACTED, ');
            end
            if (obj.isGripperClosed)
                if( obj.isPlatePresent )
                    fprintf('CLOSED, PLATE');
                else
                    fprintf('CLOSED, NOPLATE');
                end
            else
                fprintf('OPEN');
            end
            fprintf('\n');
        end
    end
end
