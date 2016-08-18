function matToArff(Xloc,Yloc,uniqYloc,svArffLoc,templateLoc)
%The function converts mat file to arff format
%Yloc - location where Y.mat is saved
%uniqYloc - location where uniqY.mat is saved
%Xloc - location where X.mat is saved
%templateLoc - path of arff file template 
%svArffLoc - path to save trained data in arff file format

X = load(Xloc);
X = X.histmat;

Y = load(Yloc);
Y = Y.actmat;

fid = fopen(svArffLoc, 'w');
fid1 = fopen(templateLoc);

tline = fgetl(fid1);
while ischar(tline)
    fprintf(fid,sprintf('%s\n',tline));
    tline = fgetl(fid1);
end
fclose(fid1);

fprintf(fid,'@attribute Class { ');
uniqY = unique(Y);
for act = uniqY(1:end-1)
    fprintf(fid,sprintf('%s , ',char(act)));
end
fprintf(fid,sprintf('%s }\n\n@data\n',char(uniqY(end))));

for i=1:size(X,1)
    for j=1:size(X,2)    
        fprintf(fid,sprintf('%d , ',X(i,j)));
    end
    fprintf(fid,sprintf('%s\n',Y{i}));
end
fclose(fid);

save(sprintf('%s',uniqYloc),'uniqY');