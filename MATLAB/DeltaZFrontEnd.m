classdef DeltaZFrontEnd < hgsetget
    %PLATELOADER Controls the Beckman Coulter Plate Loader Robot
    %   Performs the basic actions to control the plate loader
    
    properties
        serialRobot_X
        serialRobot_O
        gameBoard
        gameState
        response_X
        response_O
        isConnectedX
        isConnectedO
        currentPlayer
    end
    properties (Constant = true)
        startingBoard = ['B', 'B', 'B', 'B', 'B', 'B', 'B', 'B', 'B'];
    end
    
    methods
        function obj = DeltaZFrontEnd()
           fprintf('Initializing front end')
           obj.isConnectedX = false;
           obj.isConnectedO = false;
           
           obj.response_X = 'Not connected';
           obj.response_O = 'Not connected';
           
           obj.gameBoard = obj.startingBoard;
           obj.gameState = "Press start to begin";
        end
        
        function newState = startGame(obj)
           obj.gameBoard = obj.startingBoard;
           obj.gameState = "X's turn";
           obj.currentPlayer = 'X';
           newState = obj.gameState;
        end
                
        function isValid = isValidMove(obj, pos)            
            if obj.gameBoard(pos) ~= 'B'
               isValid = 0;
            else
               isValid = 1; 
            end
        end
        
        function didMove = move(obj, pos)
            didMove = 1;            
            if (diagonalWin() == 1) || (rowWin() == 1) || (colWin() == 1)
                   obj.gameState = sprintf("%s wins!", obj.currentPlayer);
            else 
                if obj.currentPlayer == 'X'
                   obj.currentPlayer = 'O';
                else
                   obj.currentPlayer = 'X';
                end
                obj.gameState = sprintf("%s's turn", obj.currentPlayer);
            end
               
%             if isValidMove(pos)
%                obj.gameBoard(pos) = obj.currentPlayer; 
%                didMove = 1;                   
% 
%                if ((diagonalWin() || rowWin()) || colWin())
%                    obj.gameState = sprintf("%s wins!", obj.currentPlayer);
%                else 
%                    if obj.currentPlayer == 'X'
%                        obj.currentPlayer = 'O';
%                    else
%                        obj.currentPlayer = 'X';
%                    end
%                    obj.gameState = sprintf("%s's turn", obj.currentPlayer);
%                end
%             end
            
        end
        
        function response = sendMoveCommand(obj, player, pos)
            import matlab.net.*
            import matlab.net.http.*
            r = RequestMessage;
            command = sprintf('%d/%d', player, pos);
            uri = URI(['http://koenignm-pi400.wlan.rose-hulman.edu:5000/api/' command]);
            resp = send(r, uri);
            response = resp.Body.Data;
            if player == 'X'
                obj.response_X = response;
            else
               obj.response_O = response;
            end
        end
        
        function didWin = diagonalWin(obj)
           didWin = 0;
           if obj.gameBoard(1) ~= 'B'
              if (obj.gameBoard(1) == obj.gameBoard(5)) & (obj.gameBoard(1) == obj.gameBoard(9))
                 didWin = 1;
              end
              if (obj.gameBoard(3) == obj.gameBoard(5)) & (obj.gameBoard(3) == obj.gameBoard(7))
                 didWin = 1;
              end
           end
        end
        
        function didWin = colWin(obj)
           didWin = 0;
           if obj.gameBoard(1) ~= 'B'
              if (obj.gameBoard(1) == obj.gameBoard(4)) & (obj.gameBoard(1) & obj.gameBoard(7)) 
                didWin = 1;
              end
           end
           
           if obj.gameBoard(2) ~= 'B'
              if (obj.gameBoard(2) == obj.gameBoard(5)) & (obj.gameBoard(2) & obj.gameBoard(8)) 
                didWin = 1;
              end
           end
           
           if obj.gameBoard(3) ~= 'B'
              if (obj.gameBoard(3) == obj.gameBoard(6)) & (obj.gameBoard(3) & obj.gameBoard(9)) 
                didWin = 1;
              end
           end
        end
        
        function didWin = rowWin(obj)
           didWin = 0;
           if obj.gameBoard(1) ~= 'B'
              if (obj.gameBoard(1) == obj.gameBoard(2)) & (obj.gameBoard(1) & obj.gameBoard(3)) 
                didWin = 1;
              end
           end
           
           if obj.gameBoard(4) ~= 'B'
              if (obj.gameBoard(4) == obj.gameBoard(5)) & (obj.gameBoard(4) & obj.gameBoard(6)) 
                didWin = 1;
              end
           end
           
           if obj.gameBoard(7) ~= 'B'
              if (obj.gameBoard(7) == obj.gameBoard(8)) & (obj.gameBoard(7) & obj.gameBoard(9)) 
                didWin = 1;
              end
           end
        end
        
        function didConnect = connectOnPort(obj, player, portNumber)
           if player == 'X'
              fprintf('Connecting to X robot...');
              % For direct connection to computer
              % portStr = sprintf('COM%d',portNumber);
              % For connection through pi
              portStr = sprintf('/dev/%s', portNumber);
              obj.serialRobot_X = serialport(portStr, 9600, "Timeout", 15);
              writeline(obj.serialRobot_X, 'INITIALIZE');
              obj.response_X = readline(obj.serialRobot_X);
              fprintf(obj.response_X);
              if obj.response_X ~= ""
                 didConnect = false;
              else
                  didConnect = true;
                  obj.isConnectedX = true;
              end
           else 
              fprintf('Connecting to O robot...');
              % For direct connection to computer
              % portStr = sprintf('COM%d',portNumber);
              % For connection through pi
              portStr = sprintf('/dev/%s', portNumber);
              obj.serialRobot_O = serialport(portStr, 9600, "Timeout", 15);
              writeline(obj.serialRobot_O, 'INITIALIZE');
              obj.response_O = readline(obj.serialRobot_O);
              fprintf(obj.response_O);
              if obj.response_O ~= ""
                 didConnect = false;
              else
                  didConnect = true;
                  obj.isConnectedO = true;
              end
           end
        end
        
        function isConnected = getConnectedX(obj)
           isConnected = obj.isConnectedX;
        end
        
        function isConnected = getConnectedO(obj)
           isConnected = obj.isConnectedO;
        end
        
        function mark = getMarkAt(obj, pos)
           mark = obj.gameBoard(pos); 
        end
        
        function board = getGameBoard(obj)
            % Returns the status properties of the robot (for GUI display)
            board = obj.gameBoard;
        end
        function disp(obj)
            fprintf('Board:\n');
            fprintf('%s | %s | %s\n', obj.gameBoard(1), obj.gameBoard(2), obj.gameBoard(3));
            fprintf('---------\n');
            fprintf('%s | %s | %s\n', obj.gameBoard(4), obj.gameBoard(5), obj.gameBoard(6));
            fprintf('---------\n');
            fprintf('%s | %s | %s\n', obj.gameBoard(7), obj.gameBoard(8), obj.gameBoard(9));
        end
    end
end
