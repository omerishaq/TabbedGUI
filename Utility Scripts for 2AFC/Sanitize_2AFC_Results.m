% Script created for the ML-2015 project
% Created by Omer Ishaq. Copy right @ omer.ishaq@gmail.com
% Input:
%
% Output:
%
% Action: The script is a utility script written to assist the 2AFC tool, it does the following
%
% 1. Finds data for a particular image.
% 2. Finds and sorts the results into fg and bg classes.
%

clearvars
clear global % for removing global variables
close all
clc

% set the required parameters below.
data_folder = '0002_Data.mat';
results_folder = '0002_Results.mat';
image_name = 'slow_20ms_15msexp0002.png';                       % THIS CHANGES DEPENDING ON DATA
fg_folder = 'fg_folder';
bg_folder = 'bg_folder';

% read the data folder
% find the unique image names in that data and then set the image_name above;
% read the spot data acording to the image_name
% read the corresponding results folder
% overlay data
% threshold into fg and bg
% put in two other folders

data = load (data_folder);
data = data.struct_data;

vec_img = unique(cat(1, data.img),'rows');
disp (vec_img);

[m] = arrayfun(@(x) strcmp(x.img, image_name), data,'uniformoutput',false);
[indices] = find(cell2mat(m));
data = data(indices);

results = load (results_folder);
results = results.Records;

[m] = arrayfun(@(x) strcmp(x.img, image_name), results,'uniformoutput',false);
[indices] = find(cell2mat(m));
results = results(indices);

% overlay data
for i = 1:2:length (data)
    
    this_data = data(i);
    instance_count = 0;
    positive_count = 0;
    for j = 1:length(results)
        
        if this_data.r == results(j).r && this_data.c == results(j).c
            instance_count = instance_count + 1;
            positive_count = positive_count + results(j).peak;
        end
    end
    
    img = imread (image_name);
    
    try
        img_patch = img(this_data.r-4:this_data.r+4, this_data.c-4:this_data.c+4);
    catch E
        continue;
    end
    
    if positive_count / instance_count == 1
        imwrite(img_patch, [fg_folder '\' generate_Random_String() '.png']);
        disp(['Positive count ' num2str(i)]);
    elseif positive_count / instance_count < .8
        imwrite(img_patch, [bg_folder '\' generate_Random_String() '.png']);
        disp(['Negative count ' num2str(i)]);
    end
    
end










