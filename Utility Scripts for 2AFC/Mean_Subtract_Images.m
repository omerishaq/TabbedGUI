% Script created for the ML-2015 project
% Created by Omer Ishaq. Copy right @ omer.ishaq@gmail.com
% Input:
%
% Output:
%
% Action:
% 1. compute mean image
% 2. subtract mean image

% Specify the folder from which the images are to be flipped
%

source_Folder = 'C:\Users\Omer\Dropbox\Test data folder\Flipped Data';
destination_Folder = 'C:\Users\Omer\Dropbox\Test data folder\Mean subtracted data';
source_File_Ext = '.tif';
save_File_Prefix = 'Mean subtracted';

files = dir([source_Folder '\*' source_File_Ext]);

for i = 1:length(files)
    
    file_Name = [source_Folder '\' files(i).name];
    file_Data = imread(file_Name);
    
    files_Stack(:,:,i) = file_Data;
    
end

file_Mean   = mean(double(files_Stack), 3); 
file_Std    = std(double(files_Stack), 0, 3);
clear files_stack;

for i = 1:length(files)
    
    file_Name = [source_Folder '\' files(i).name];
    file_Data = double(imread(file_Name));
    
    file_Data = file_Data - file_Mean;
    file_Data = file_Data ./ file_Std;
    file_Data = file_Data + 10;
    
    min1 = 0;   %min(file_Data(:)); 
    max1 = 20; %max(file_Data(:)); 
    file_Data = round((file_Data-min1) * ((255-0)/(max1-min1)));

    file_Data = uint8(file_Data);
    imwrite(file_Data, [destination_Folder '\' save_File_Prefix '_' files(i).name])
end

% save mean file
%
% still work remining on saving mean file

%imwrite(file_Mean, [destination_Folder '\' 'DATA_MEAN_FILE' source_File_Ext])
