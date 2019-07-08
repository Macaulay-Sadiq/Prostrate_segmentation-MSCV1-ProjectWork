function  areaImages  = calculateArea( imgTumor, imgCentral, imgPeri, imgTemporal, info)
%this function calculates area of the regions of prostarte gland
% input : mask of segmented region and slice information about slice
% spatial resolution
% output : an array of values representing the area of respective segment

images = {imgTumor, imgCentral, imgPeri, imgTemporal};
areaImages = [];

for i = 1:length(images)
    stats = regionprops(images{i}, 'Area'); %to get region properties
    allAreas = [stats.Area]; % to get all areas
    area = sum(allAreas); % sum up all pixels
    
    area = area * info; % pixels * spacing
    area = round(area,1);
    areaImages = [areaImages area];
    
end

