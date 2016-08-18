function cropped = resizeToBoxsize(cropped,boxsz)
%reurns the resized image 
%size of resized image - boxsz*x or x*boxsz where x<=boxsz
%cropped - image to be resized
%boxsz - max(height,width) of  the final image

ht = size(cropped,1);wt = size(cropped,2);
if ht > wt
    ratio = boxsz/ht;
else
    ratio = boxsz/wt;
end
cropped = imresize(cropped,ratio);

end