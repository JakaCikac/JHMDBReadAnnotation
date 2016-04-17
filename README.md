# JHMDBReadAnnotation
Convert the Matlab annotation of JHMDB dataset (stored as .mat) to YAML and read it as OpenCV cv::Mat in C++.

The [JHMDB dataset](http://jhmdb.is.tue.mpg.de "JHMBD Dataset") provides annotations in .mat files (joint_positions.mat). The purpose of this utility program is to convert the annotations into a C++ form for later processing. 

The annotations are first converted, using MATLAB, into a YAML file. This YAML file is then easily read by the OpenCV FileStorage class. After being read in the annotations are available as cv::Mat and can be used for later implementations of various algorithms.

##JHMDB_MatToYAML
Recursively go through a directory to find the paths to all *joint_positions.mat* file's paths. Then convert them to YAML files readable by ReadJHMDBAnnotations (C++).

The project has the following dependencies:
    
    Enhanced_rdir  REQUIRED (for recursive directory listing, link provided in the runMatlabOpenCV.m)

####RUNNING
To run, open MATLAB and open runMatlab2OpenCV.m. Set the approapriate paths and options (read the comments).

####TESTING
There is an example joint_positions.mat included in the folder Example/. You can use this for a single file conversion test.

##ReadJHMDBAnnotations
Read a YAML stored joint positions annotations of JHMDB into OpenCV cv::Mat.

The project has the following dependencies:
    
    OpenCV  REQUIRED (installed with c++11 and ffmpeg support for videos)
    CMake   REQUIRED (for building)
    Doxygen OPTIONAL (for documentation)

####BUILDING
To configure the project, set the options at the top of CMakeLists.txt
To build the project:

    >> mkdir build
    >> cd build/
    >> cmake ..
    >> make -j8
	
####RUNNING
The program requires two arguments.
	1. the path to the video file you wish to annotate / process / display
	2. the path to the joint_positions.yaml generated file
	
####TESTING
There is an example provided in the data/ folder. You can use the "Goal_Keeping_Tips_catch_f_cm_np1_fr_med_2.avi" video file as the first argument and it's corresponding annotations "joint_positions.yaml" as the second argument to the program.
A window containing the video frame 1 should show up with the joint annotations for the first frame drawn on top as red circles as in the example image. Use any key to proceed to the next frame. 

#####Example Image
![Example image](/ReadJHMDBAnnotations/data/example_image/example.png)
