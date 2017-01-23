/*! \mainpage C++ (OpenCV) Reader for JHMDB database annotations.
 *
 *   Provides the reading and visualization of annotations in the JHMDB example.
 *   Takes as first input argument the path to the video.
 *   Takes as second input argument the path to the joint_positions.yaml generated
 *   by MATLAB function Matlab2OpenCV.m (run it with runMatlab2OpenCV.m).
 *
 *   The result is a video (which you can view frame by frame) with displayed (as
 *   red circles) the annotated joints.
 *
 *   This is only a utility program to be used as an example to do more things with
 *   the JHMDB database in C++ (as they use MATLAB apparently).
 *
 *   Author: Jaka Cikac, University of Ljubljana, April 2016
 *   Version: 0.1
 */

#include <iostream>
#include <string>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;
using namespace std;

vector<Mat> readJointPositions(string yaml_file) {
    // Initialize file storage reader.
    FileStorage fsReader( yaml_file, FileStorage::READ);

    // Read in the total number of frames.
    int frameCount (0);
    fsReader["numFrames"] >> frameCount;

    // Read in the frame name.
    string frame_name;
    fsReader["framePrefix"] >> frame_name;

    // Initialize the frames as a vector.
    vector<Mat> frames;

    // Matlab starts indexing at 1 ..
    for (int i = 1; i <= frameCount; i++) {

        // Get the current frame name.
        ostringstream current_frame;
        current_frame << frame_name << "_" << i;

        Mat temp;
        // Read in the current frame.
        fsReader[current_frame.str()] >> temp;

        // Append to the vector.
        frames.push_back(temp);
    }

    // Cleanup.
    fsReader.release();

    return frames;

}

int main (int argc, char * const argv[])
{

    // Read the video file as an argument to the program
    VideoCapture cap(argv[1]);
    if( !cap.isOpened()){
        cout << "Cannot open the video file" << endl;
        return -1;
    }

    // Get the frame count
    // (it's different than in the database, they cut some frames, but no matter)
    double frameCount ( cap.get ( CV_CAP_PROP_FRAME_COUNT ) );

    // Read in the joints positions.
    vector<Mat> frames = readJointPositions(argv[2]);

    namedWindow("JHMDB Video", CV_WINDOW_AUTOSIZE);

    int frameCounter = 0;

    while(1) {

        Mat frame;
        bool success = cap.read(frame);
        if (!success) {
            cout << "Cannot read frame " << endl;
            break;
        }

        // Some C++ 11 initialization hehe.
        float x {0.0};
        float y {0.0};
        // Plot the dot of the joints on the frame
        cout << "Frame: " << frameCounter << endl;
        for (int joint = 0; joint < frames[0].cols; joint++) {

            // Retrieve x and y coordinate.
            x = frames[frameCounter].at<float>(0, joint);
            y = frames[frameCounter].at<float>(1, joint);
            cout << "x = " << x << " y = " << y << endl;
            // Draw a circle
            circle(frame, Point(x, y), 2.0, Scalar(0, 0, 255), 3, 8);

        }

        // Hold space to play video, press space to move to the next frame
        imshow("JHMBD Video Sequence", frame);
        // Increase frame counter
        frameCounter += 1;

        if (waitKey(0) == 27) break;
    }

    return 0;
}