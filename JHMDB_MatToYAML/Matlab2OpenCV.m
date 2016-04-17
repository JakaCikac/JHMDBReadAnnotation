% =========================================================================
%   This function converts the JHMDB joint_positions.mat variable pos_img
%   into a YAML file, that the C++ program can then read.
%
%   Author: Jaka Cikac, University of Ljubljana, April 2016
%
%   Based on: 
%   https://stackoverflow.com/questions/11550021/converting-a-mat-file-from-matlab-into-cvmat-matrix-in-opencv
% =========================================================================
function Matlab2OpenCV( variable, fileName, flag, numFrame, frames)
%   Write the YAML file with 2D matrices.
%
%   INPUTS:
%       variable: name of the current matrix
%       fileName: name of the output yaml file
%       flag:     w for writing a new file, a for appending to the file
%       numFrame: if there is a third dimension, numFrame is the current
%                 number of the 'frame' (as in rows,cols,frames)
%       frames:   the total number of frames (or third dimension)
%   OUTPUTS:
%       none, however it does output a .yaml file. For an example see the
%       provided joints.yaml file.
% =========================================================================
% Get the size of the current matrix.
[rows cols] = size(variable);

% Beware of Matlab's linear indexing
variable = variable';

% Write mode as default
if ( ~exist('flag','var') )
    flag = 'w'; 
end

if ( ~exist(fileName,'file') || flag == 'w' )
    % New file or write mode specified 
    file = fopen( fileName, 'w');
    fprintf( file, '%%YAML:1.0\n');
    if (numFrame == 1)
        % Add the number of frames and the name of the variables
        fprintf( file, '    numFrames: %d\n', frames );
        fprintf( file, '    framePrefix: %s\n', inputname(1) );
    end
else
    % Append mode
    file = fopen( fileName, 'a');
end

% Write the header for the Opencv Matrix
fprintf( file, '    %s: !!opencv-matrix\n', sprintf('%s_%d', inputname(1), numFrame ));
fprintf( file, '        rows: %d\n', rows);
fprintf( file, '        cols: %d\n', cols);
fprintf( file, '        dt: f\n');
fprintf( file, '        data: [ ');

% Write variable data
for i=1:rows*cols
    fprintf( file, '%.6f', variable(i));
    if (i == rows*cols), break, end
    fprintf( file, ', ');
    if mod(i+1,4) == 0
        fprintf( file, '\n            ');
    end
end

fprintf( file, ']\n');
fclose(file);