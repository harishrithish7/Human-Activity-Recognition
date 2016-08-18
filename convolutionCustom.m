function convmat = convolutionCustom(imageToApply,template)
%Returns the convolution of imageToApply with template
%Returns only those parts of the convolution that are computed without the zero-padded edges.

convmat = conv2(single(imageToApply),single(template),'valid');
end