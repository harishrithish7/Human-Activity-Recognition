# Human-Acitivity-Recognition
Detect humans falling on the ground from a CCTV camera feed and limit the physical damage to the person by alerting the hospital authorities.

Introduction
------------
Elderly people tend to slip and fall in homes and remain unattended for a long time. 
If the affected person is not treated immediately, serious health issues including brain injuries occur. 
The proposed solution automatically detects humans falling, through cameras installed in homes, and sends notification to family members and hospital authorities.

Requirements
------------
1. MATLAB R2013a  
2. WEKA 3.7

Usage 
-----

####Installation

1. Download zip 
2. Unzip 
3. Open recognizer.m in MATLAB 

####MATLAB command line
```matlab
recognizer <weka_path> <video_name>;
```
####Example
```matlab
recognizer 'C:\Program Files\Weka-3-7\weka.jar' video.avi;
```

Output
------
###Working
[![giphy.gif](https://s4.postimg.org/49t4relod/giphy.gif)](https://postimg.org/image/qlqxksks9/)

###Original video frame
[![frame.png](https://s3.postimg.org/5a8votdrn/frame.png)](https://postimg.org/image/84c129fxr/)

###Human Segmented image
[![mask.png](https://s4.postimg.org/90btq8j71/mask.png)](https://postimg.org/image/nwacxtull/)

###Recognized Activity
[![box.png](https://s4.postimg.org/nukgkv8v1/box.png)](https://postimg.org/image/w02ij0x3t/)

YouTube Demo Video Link
------------------
Demo of the project

<a href="http://www.youtube.com/watch?feature=player_embedded&v=LdoLniUSOaA
" target="_blank"><img src="http://img.youtube.com/vi/LdoLniUSOaA/0.jpg" 
alt="Youtube Video: Human Fall Detection" width="240" height="180" border="10" /></a>

Flowchart
---------
[![Page-4-Image-27.png](https://s4.postimg.org/lfue0o4fh/Page_4_Image_27.png)](https://postimg.org/image/8og7u5und/)

Note
----
* Live transmission from the camera to the software is not supported. Instead, the data from the camera is first stored and then processed.
* The video feed should be saved in '..\Fall-Detection\Video' folder.
* The notification is sent to the user through an app installed on the phone. The apk file is not included in this repository.

Reference Paper
---------------
C.Rougier,J.MeunierFall,A.Arnaud and J.Rousseau. Detection from Human Shape and Motion History using Video Surveillance. *Proceedings of the 21st International Conference on Advanced Information Networking and Applications Workshops*,2007. 





