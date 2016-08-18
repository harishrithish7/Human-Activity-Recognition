function test(vidname,templateLoc,testDbLoc,modelLoc,imLoc,wekaLoc,testFileLoc,uniqYloc,height,width,alpha,boxsz,cropDivN,minFrameNo)

%adding java files to the path of matlab
javaaddpath(wekaLoc);

%importing required weka files
import weka.classifiers.*;
import weka.core.*;
import weka.classifiers.trees.*;
import java.io.*;

%creating new file to save the test features by copying the template file
%into it
fid1 = fopen(templateLoc);
fid2 = fopen(testDbLoc,'w');
tline = fgetl(fid1);
while ischar(tline)
    fprintf(fid2,sprintf('%s\n',tline));
    tline = fgetl(fid1);
end
fclose(fid1);

%adding class information
fprintf(fid2,'@attribute Class { ');
uniqY = load(uniqYloc);
uniqY = uniqY.uniqY;
for act = uniqY(1:end-1)
    fprintf(fid2,sprintf('%s , ',char(act)));
end
fprintf(fid2,sprintf('%s }\n\n@data\n',char(uniqY(end))));
fclose(fid2);


%loading trained model
load_model = load(modelLoc);
trainModel = load_model.trainModel;

% instantiating required variables
no_ang = 180/alpha;
instanceNo = 0;

tempInd = 1;
temp_all = cell(12,1);
thres_all = cell(12,1);
for ang=0:alpha:180-alpha
    temporary = load(sprintf('%sconv_%d_%d_%d.mat',imLoc,height,width,ang));
    temp_all{tempInd} = temporary.temp;
    thres_all{tempInd} = sum(temporary.temp(:)==1);
    tempInd = tempInd+1;
end
clear tempInd;

videoFReader = vision.VideoFileReader(strcat(strcat(testFileLoc),vidname));
detector = vision.ForegroundDetector('NumTrainingFrames',10,'NumGaussians',5);
blob = vision.BlobAnalysis(...
    'CentroidOutputPort', false, 'AreaOutputPort', false, ...
    'BoundingBoxOutputPort', true, ...
    'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);

frameNo = 0;
while ~isDone(videoFReader)
    frame = step(videoFReader);
    frameNo = frameNo+1;
    
    fgMask = step(detector,frame);
    box = step(blob,fgMask);
    
    %cond1 - current frame number is greater than threshold frame number. This condition is kept too ensure that initial not good foreground masks are removed.
    %cond2 - One bounding box returns 1*4 matrix. Hence it checks if one bounding exisits in the mask
    cond1 = (frameNo >= minFrameNo);
    cond2 = (size(box,1) == 1 && size(box,2) == 4);
    
    if cond1 && cond2
        %cropping the fgMask to the bounding box
        cropped = cropToBoundingBox(fgMask,box);
        %resizing the bounding box image to a boxsz*x or x*boxsz dimension where x<=boxsz
        cropped = resizeToBoxsize(cropped,boxsz);
        
        %finding cropheight and cropwidth of the small boxes(3*3) inside
        %the bounding box
        cropht = size(cropped,1);cropwt = size(cropped,2);
        nwcropht = floor(cropht/cropDivN);
        nwcropwt = floor(cropwt/cropDivN);
        
        histframe = zeros(1,(no_ang*cropDivN*cropDivN));
        histframeInd=1;
        
        %looping through each division in cropped bounding box and
        %extracting feature information for testing
        for xi=1:cropDivN
            histrow = zeros(1,no_ang*cropDivN);
            histrowInd = 1;
            for yi=1:cropDivN
                newcrop = cropped((nwcropht*(xi-1))+1:nwcropht*xi,(nwcropwt*(yi-1))+1:nwcropwt*yi);
                histbox = zeros(1,no_ang);
                histTempInd = 1;
                tempInd = 1;
                for ang=0:alpha:180-alpha
                    temp = temp_all{tempInd};
                    thres = thres_all{tempInd};
                    tempInd = tempInd+1;
                    
                    if size(temp,1)>size(newcrop,1) || size(temp,2)>size(newcrop,2)
                        continue
                    end
                    
                    %convolution of the template(temp) on the image(newcrop).The convoluted image is then cropped to the size of image(newcrop)
                    convmat = convolutionCustom(newcrop,temp);
                    
                    %The histogram corresponding to 'i'th angle(ang) is
                    %equated to the number of elements in convolution
                    %matrix(convmat) that is greater than threshold(thres)
                    histbox(histTempInd) = sum(convmat(:)>=thres);
                    histTempInd = histTempInd+1;
                end
                histrow(no_ang*(histrowInd-1)+1:no_ang*histrowInd) = histbox;
                histrowInd=histrowInd+1;
            end
            histframe(no_ang*cropDivN*(histframeInd-1)+1:no_ang*cropDivN*histframeInd) = histrow;
            histframeInd=histframeInd+1;
        end
        
        %appending extracted features to predict file
        fid = fopen(testDbLoc, 'a');
        for i=histframe
            fprintf(fid,sprintf('%d , ',i));
        end
        fprintf(fid,'?\n');
        fclose(fid);
        
        loader = weka.core.converters.ArffLoader();
        loader.setFile( java.io.File(testDbLoc) );
        ft_test_weka = loader.getDataSet();
        
        %assigning last attribute as the class attribute
        ft_test_weka.setClassIndex(ft_test_weka.numAttributes() - 1);
        
        %predicting the output with the trained classifier trainModel
        predict = ft_test_weka.instance(instanceNo).classAttribute.value(trainModel.classifyInstance(ft_test_weka.instance(instanceNo))).char();
        sprintf('%s',predict)
        instanceNo = instanceNo+1;
        
        %clearing java objects
        clear loader;
        clear ft_test_weka;
        clear ft_train_weka;
    end
    subplot(1,3,1);
    imshow(frame);
    title(sprintf('Original Video\nFrame no - %d',frameNo),'FontSize',20);
    subplot(1,3,2);
    imshow(fgMask);
    title(sprintf('Segmented Human'),'FontSize',20);
    if cond1 && cond2
        subplot(1,3,3);
        imshow(frame);
        title(sprintf('Activity - %s',predict),'FontSize',20);
        rectangle('Position', [box(1),box(2),box(3),box(4)],...
                    'EdgeColor','r','LineWidth',2 )
    end
    %
end
release(videoFReader);

%clearing  java objects
clear trainModel;
