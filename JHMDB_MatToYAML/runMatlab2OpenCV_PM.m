% =========================================================================
%   This script runs the Matlab2OpenCV.m for the JHMDB joint_positions.mat
%   conversion, first into a YAML file, that the C++ program can then read.
%   
%   First part of the script shows how to convert a single
%   joint_positions.mat file.
%
%   Second part of the script shows how to convert all joint_positinons.mat
%   files in subfolders given a root directory. 
%   The joint_positions.mat files are placed in subfolders named after the
%   movie clip. After creating the .yaml files, the root folder can be
%   given as an argument to the C++ program, that will then convert them to
%   OpenCV mat. 
%   The YAML files will be placed next to the original joint_positions.mat.
%
%   Author: Jaka Cikac, University of Ljubljana, April 2016
%   
%   Depends on: RDIR -for recursive directory listing, available at the
%   link. 
%   However!! The provided version of Enchanced_dir is modified - I added
%   the exclusion of .AppleDouble directories when running on Mac OS X!
%
%   http://www.mathworks.com/matlabcentral/fileexchange/32226-recursive-directory-listing-enhanced-rdir
% =========================================================================
%% Notes and settings:

% NOTE on speed:
% Since this works recursively and there is 928 joint_positions.mat files,
% this will take some time to convert to YAML.
% On a Mac Mini, OS X 10.11, Core i7 2.3 Ghz it took:  102.829591 seconds

tic;
% Set to 1 if you want to run for a single file and adjust the path!
run_single_file = 1;
% Set to 1 if you want to run for multiple subfolders, recursively.
run_recursively = 0;
% Don't forget to adjust the paths!!
%  the subfolders contain joint_positions.mat (as in JHMDB)
addpath('./Enhanced_rdir/');
%jhmdb_joint_position_folder = '/Users/natrixanorax/Documents/JHMDB/joint_positions/';
%jhmdb_joint_position_folder = '/Users/natrixanorax/Documents/JHMDB/estimated_joint_positions/';

%% Load s single joint_positions.mat file and convert it to yaml,
%  that the C++ program can read.
if run_single_file
    
    % Load matrix of joints (2 x 15 x 40) from a given folder.
    folder = '/home/nanorax/Desktop/video/';
    filename = 'joint_positions_MVI_6253.m4v.mat';
    load([folder, filename]);

    % Get the sizes of the variable we are interested in:
    [rows cols frames] = size(predictionMat);

    % Define a temporary 2x15 matrix.
    frame = zeros(rows, cols);

    % Check if the yaml file exists already and delete it.
    outputFilename = 'joints.yaml';

    if exist(outputFilename, 'file') == 2
       delete(outputFilename);
    end

    % Write frames to YAML, frame by frame (since !!opencv-matrix type only 
    % supports 2D)
    for i = 1:frames
        frame = predictionMat(:,:,i);
        Matlab2OpenCV(frame, [folder 'joints.yaml'], 'a', i, frames);
    end

end

if run_recursively
    % =========================================================================
    %% Do this recursively for a root folder in which
    % This is the subfolder structure for the JHMDB join_positions folder!
    % Change this is you plan on running it on something else.
    subfolder_structure = '*/**/*.mat';
    
    % List all paths to joint_positions.mat files
    d2 = rdir([jhmdb_joint_position_folder, subfolder_structure]);
    
    numall = numel(d2);
    for i = 1:numel(d2)
        % Load matrix of joints (2 x 15 x 40) from a given folder.
        load(d2(i).name);
        % Extract only the path.
        [pathstr, name, ext] = fileparts(d2(i).name);
        count = sprintf('(%d / %d)', i, numall);
        disp(['Working on ', count, ' : ', d2(i).name]);

        % Get the sizes of the variable we are interested in:
        [rows cols frames] = size(pos_img);

        % Define a temporary 2x15 matrix.
        frame = zeros(rows, cols);

        % Check if the yaml file exists already and delete it.
        outputFilename = 'joint_positions.yaml';

        if exist(outputFilename, 'file') == 2
           delete(outputFilename);
        end

        % Write frames to YAML, frame by frame (since !!opencv-matrix type only 
        % supports 2D)
        for i = 1:frames
            frame = pos_img(:,:,i);
            Matlab2OpenCV(frame, [pathstr, '/', outputFilename], 'a', i, frames);
        end

        % clear currently loaded joint_positions.mat file
        clear pos_img
        clear pos_world
    end
% =========================================================================
end
toc;










