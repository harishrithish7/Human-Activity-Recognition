function [] = recognizer(vidname)

%Main function to predict action in videos
wekaLoc = 'C:\Program Files\Weka-3-7\weka.jar';

%% location and paths to various files
[path,name,ext] = fileparts(mfilename('fullpath'));

%location of testing videos
testFileLoc = sprintf('%s\\videos\\',path);

%location where uniqY.mat is saved
uniqYloc = sprintf('%s\\models\\uniqY.mat',path);
%loaction of saved oriented rectangles
imLoc = sprintf('%s\\convolution\\',path)';
%path of arff file template 
templateLoc = sprintf('%s\\models\\template.arff',path);
%path of saved trained weka model
svModelLoc = sprintf('%s\\models\\model.mat',path);
%path to save predicted data in arff file format
testDbLoc = sprintf('%s\\models\\predict.arff',path);
%% parameters 

%height of oriented rectangles
height = 15;
%width of oriented rectangles
width = 5;
%orientation change
alpha = 15;
%maximum(height,width), where height and width are the dimensions to resize
%to bounding box
boxsz = 200;
%if N is cropDivN, then N*N is the number of divisions in the cropped
%bounding box
cropDivN = 3;
%minimum frame number after which predictions take place
minFrameNo = 13;

%% function calls

test(vidname,templateLoc,testDbLoc,svModelLoc,imLoc,wekaLoc,testFileLoc,uniqYloc,height,width,alpha,boxsz,cropDivN,minFrameNo);