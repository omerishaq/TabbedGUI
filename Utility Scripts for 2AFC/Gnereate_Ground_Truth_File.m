% Script created for the ML-2015 project
% Created by Omer Ishaq. Copy right @ omer.ishaq@gmail.com
% Input:
%
% Output:
%
% Action: Generate a file for specifying the Ground truth for caffe
% 
%

%
% Data variable allocation
%

source_Folder = 'bg_testing';
source_File_Ext = '.png';

groundtruth_File_Name = 'testing.txt';
groundtruth_Prefix = 'signals/testing/';

groundtruth_Label = '1';

%
% Get the file details 
%

files = dir([source_Folder '\*' source_File_Ext]);

%
% Check if the .txt file exists.
%

if exist([groundtruth_File_Name], 'file') == 2
    % append
    fid = fopen([groundtruth_File_Name], 'a+');
    for i = 1:length(files)
        fprintf(fid, '%s\n', [groundtruth_Prefix files(i).name ' ' groundtruth_Label]);
    end
    fclose(fid);
else
    % create
    fid = fopen([groundtruth_File_Name], 'w');
    for i = 1:length(files)
        fprintf(fid, '%s\n', [groundtruth_Prefix files(i).name ' ' groundtruth_Label]);
    end
    fclose(fid);
end

