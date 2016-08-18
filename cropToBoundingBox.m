function cropped = cropToBoundingBox(fgMask,box)
%Returns the rectangular cropped image from fgMask 
%fgMask - image to be cropped
%box - [x y width height] , where x,y are co-ordinates of the left corner
%                           of the rectangle

x1 = box(2);x2 = box(2)+box(4);y1 = box(1);y2 = box(1)+box(3);
if box(2)+box(4)> size(fgMask,1)
    x2 = size(fgMask,1);
end
if box(1)+box(3)> size(fgMask,2)
    y2 = size(fgMask,2);
end
cropped = fgMask(x1:x2,y1:y2);

end