% Things still to be done for the Tab2
% - Introduce the red and green squares around the smaller images.
% - Introduce the next and behind images.
% - Introduce the enable disbale function and radio button for next and
% behind images
% - 

function [ output_args ] = create_GUI_tab2( settings, hTabGroup)
%UNTITLED Function for creating the single image tab.
%   Detailed explanation goes here

global view;

tab1_X_offset = 50;
tab1_Y_offset = 150;
tab1 = uitab(hTabGroup, 'title','Single Image');

position = view.position(2,:);

ui_text = uicontrol(tab1, 'Style', 'text', 'String', 'Specify file name',...
    'Position', [0+tab1_X_offset position(4)-tab1_Y_offset 150 25],'HorizontalAlignment','left');
ui_edit_text = uicontrol(tab1, 'Style', 'edit',...
    'Position', [155+tab1_X_offset position(4)-tab1_Y_offset settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left');
view.tab2.edit_file = ui_edit_text;
align([ui_text ui_edit_text],'None','Middle');

ui_button_select = uicontrol(tab1, 'Style','pushbutton', 'String','Load',...
    'Position',[185+tab1_X_offset position(4)-(tab1_Y_offset+30), settings.active.button_lengthX, settings.active.button_lengthY], 'Callback', @select_DataFile);
align([ui_button_select ui_edit_text],'Right','None');
view.tab2.button_select = ui_button_select;

ui_button_red = uicontrol(tab1, 'Style','pushbutton', 'String','Red', 'BackgroundColor', [1 0 0],...
    'Position',[15+tab1_X_offset position(4)-(tab1_Y_offset+230), settings.active.button_lengthX, settings.active.button_lengthY], 'Callback', @execute_Red);
view.tab2.button_red = ui_button_red;

ui_button_green = uicontrol(tab1, 'Style','pushbutton', 'String','Green', 'BackgroundColor', [0 1 0],...
    'Position',[205+tab1_X_offset position(4)-(tab1_Y_offset+230), settings.active.button_lengthX, settings.active.button_lengthY], 'Callback', @execute_Green);
view.tab2.button_green = ui_button_green;

ui_progress = uicontrol(tab1, 'Style', 'text', 'String', 'Image 0 of 0',...
    'Position', [80+tab1_X_offset position(4)-(tab1_Y_offset+280), 200, 30],'HorizontalAlignment','Center');
view.tab2.text_progress = ui_progress;

% create the main axis here
ah = axes('Parent', tab1, 'Position',  [.25 .05 settings.active.magnification+0.3 settings.active.magnification+0.3], 'Box', 'off');
view.tab2.axes_main = ah; 
hold on; axis off; axis equal;

% create the 'left red' minor axis here
ah1 = axes('Parent', tab1, 'Position',  [0.04 0.58 0.16 0.20], 'Box', 'off');
view.tab2.axes_red_left = ah1; 
hold on; axis off; axis equal;

% create the 'right green' minor axis here
ah2 = axes('Parent', tab1, 'Position',  [0.202 0.58 0.16 0.20], 'Box', 'off');
view.tab2.axes_green_right = ah2; 
hold on; axis off; axis equal;
 


end

function select_DataFile(hObject, event, handles)
    global model
    global view
    
    [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.png');
    model.strings.imgfilename = FILENAME;
    model.strings.imgfilepath = PATHNAME;

    model.image.input = imread([model.strings.imgfilepath model.strings.imgfilename]);
    set(view.tab2.edit_file,'String',[model.strings.imgfilename]);
    update_Tab2_MainAxes();
    
    tempfilename = model.strings.imgfilename(1:end-4);
    model.struct.f_data = csvread([ model.strings.imgfilepath tempfilename '.csv'], 1, 0);
    
    % here comes the function to setup the initial code for single view
    setup_SingleView_Logic();
    
end

function update_Tab2_MainAxes()

    global model;
    global view;
    imshow(model.image.input, 'Parent', view.tab2.axes_main);
    
end

function update_Tab2_MinorAxes()

global model;
global view;
 
axes(view.tab2.axes_main) 
curAxisProps=axis;
rectangle('Position',[model.struct.up.c-6, model.struct.up.r-6,13,13],'EdgeColor','r');
axis(curAxisProps)

axes(view.tab2.axes_main) 
curAxisProps=axis;
rectangle('Position',[model.struct.down.c-6, model.struct.down.r-6,13,13],'EdgeColor','g');
axis(curAxisProps)

imshow(model.image.input(model.struct.up.r-4:model.struct.up.r+4, model.struct.up.c-4:model.struct.up.c+4), 'Parent', view.tab2.axes_red_left); 
imshow(model.image.input(model.struct.down.r-4:model.struct.down.r+4, model.struct.down.c-4:model.struct.down.c+4), 'Parent', view.tab2.axes_green_right); 

end

function [img_output] = firstproc_Image_Tab2(img_input) 

    global model;

    img_denoised = img_input; % directly taken from parameter since no denoising being done now
    img_double = double(img_denoised);

    Data = []; % This part needs to be changed so that the as many additional parameters can be incorporated as possible 
    
    for k = 1:size(model.struct.f_data,1)  %%% ...length(int_linearindices_high)
        Data(k).img = model.strings.imgfilename;
        Data(k).peak = model.struct.f_data(k,4); %%% ... sum(img_grade_high(int_R_high(k), int_C_high(k), :));
        Data(k).sigma = model.struct.f_data(k,3);
        Data(k).std = model.struct.f_data(k,5);
        Data(k).uncertainty = model.struct.f_data(k,6);
        Data(k).intensity = 0; %%% ... sum(sum(img_double(int_R_high(k)-2:int_R_high(k)+2, int_C_high(k)-2:int_C_high(k)+2)/54));
        Data(k).negintensity = -1*Data(k).intensity;
        Data(k).r = round(model.struct.f_data(k,2)); %%% ... int_R_high(k);
        Data(k).c = round(model.struct.f_data(k,1)); %%% ... int_C_high(k);
        Data(k).ispeak = 1;
    end

model.struct.data = nestedSortStruct(Data, 'peak');

limit = round(length(model.struct.data) * model.nums.background_ratio);

% Code below is used to set a certain percentage of the fluorophore's
% ispeak criterion to 0 which means they are being allocated to the
% background.
for k = 1:limit
    model.struct.data(k).ispeak = 0;
end

model.nums.samples = length(model.struct.data)-limit;
update_Counter();

% Reflip the data so that the data is ordered in ascending order of the
% 'peak' field of the 'Data' structure.
model.struct.data = fliplr(model.struct.data);

img_output = model.struct.data;

end

function flipviews_Tab2(struct_data)

        global model;

        % ... Now let the user perform the forced choice experiments.
        [struct_H, struct_L] = twoafc_SingleView(struct_data);

        % Flip the data if required
        if rand > 0.5
            if model.flag.debug == 1; disp('UP'); end;
            model.struct.up = struct_H;
            model.struct.down = struct_L;
        else
            if model.flag.debug == 1; disp('DOWN'); end;
            model.struct.up = struct_L;
            model.struct.down = struct_H;
        end

end

function [struct_H, struct_L] = twoafc_SingleView(struct_input) % substitutes the performforcedchoice function in the original app 

global model;

increment_Counter();

% Perform forced choice by ...

% ... Randomly select a high SNR datapoint.
[int_matches] = find([struct_input.ispeak] == 1);
struct_highSNR = struct_input(int_matches);

lenH = length(int_matches); 

model.nums.samples = lenH;

ratioH = 1; %%% ... ratioH = lenH / int_samples;
indicesH = floor([1 : ratioH : lenH]);

int_temp1 = indicesH(model.nums.samplescounter);
struct_H = struct_highSNR(int_temp1);


% ... Randomly select a low SNR datapoint.
[int_matches] = find([struct_input.ispeak] == 0);
struct_lowSNR = struct_input(int_matches);

lenL = length(int_matches); 

%%% Use the code below if you want to select the signals from the
%%% background determiniistically, i.e., similar to the way they are
%%% selected for the foreground.
% ratioL = lenL / int_samples;
% indicesL = floor([1 : ratioL : lenL]);
% int_temp2 = indicesL(int_samplescounter);

randnum = floor(rand * lenL);
if model.flag.debug == 1;  disp(['Low Index = ' num2str(randnum)]); end
if randnum == 0
    struct_L = struct_lowSNR(1);
else
    try
    struct_L = struct_lowSNR(randnum);
    catch 
        a = 10;
    end
end

% Increment the counter
% model.nums.samplescounter = model.nums.samplescounter + 1;

end

function loadNeighborImages()

end

function setup_SingleView_Logic()

    global model;

    % Load the Data file
if exist(model.strings.datafilename, 'file')
    % Data file exists, therefore ...
    
    % ... Load all the data.
    temp_data = load(model.strings.datafilename);
    
    % ... Find if the image has already been added to the database.
    matchf = 0;
    for i = 1:length(temp_data.struct_data)
        if strcmp(temp_data.struct_data(i).img, model.strings.imgfilename);
            matchf = 1;
            break
        end
    end
    
    % ...If match found
    if matchf == 1
        struct_data = [];
        for i = 1:length(temp_data.struct_data)
            if strcmp(temp_data.struct_data(i).img, model.strings.imgfilename);
                struct_data = [struct_data temp_data.struct_data(i)];
            end
        end
        
        model.struct.data = struct_data;
        
        % code added so that the progress counter remains working properly
        % in the mode where a data.mat file exists and the image being
        % processed is already in the database.
        limit = round(length(model.struct.data) * model.nums.background_ratio);
        model.nums.samples = length(model.struct.data)-limit;
        update_Counter();
        
        flipviews_Tab2(struct_data)
        update_Tab2_MinorAxes();

    end
        
    % ... If match not found... process the image for the first time
    if matchf == 0
        [img_output] = firstproc_Image_Tab2(model.image.input);
        struct_data = img_output;

        flipviews_Tab2(struct_data)
        update_Tab2_MinorAxes();

        temp_data = load(model.strings.datafilename);
        struct_data = [temp_data.struct_data struct_data];
        save(model.strings.datafilename, 'struct_data');
    end
    
else    
    % Part of code to be executed if no Data.mat database exists...
    
    % ... Process the img for the first time
    [img_output] = firstproc_Image_Tab2(model.image.input);
    
    % ... Copy the data
    struct_data = img_output;
    save(model.strings.datafilename, 'struct_data');
    
    flipviews_Tab2(struct_data)
    update_Tab2_MinorAxes();
    
end % end of the if block

% load the next and the previous images
loadNeighborImages()

% after loading these images enable the button for navigating to these
% images
% set(handles.btnNextImage,'Enable','on');
% set(handles.btnPreviousImage,'Enable','on');

end

function execute_Red(hObject, event, handles) 

global model;

struct_record.img = model.strings.imgfilename;   
struct_record.user = model.strings.username;

% Decode this part figure out how this works

if model.struct.up.ispeak == 1
    struct_record.peak = 1;
    struct_record.r = model.struct.up.r;
    struct_record.c = model.struct.up.c;
else
    struct_record.peak = 0;
    struct_record.r = model.struct.down.r;
    struct_record.c = model.struct.down.c;
end

Records = load(model.strings.resultsfilename);
Records = Records.Records;
ilength = length(Records);
Records(ilength + 1).peak = struct_record.peak;
Records(ilength + 1).r = struct_record.r;
Records(ilength + 1).c = struct_record.c;
Records(ilength + 1).user = struct_record.user;
Records(ilength + 1).img = struct_record.img;
save(model.strings.resultsfilename, 'Records');

loadnext();

end

function execute_Green(hObject, event, handles)

global model;

struct_record.img = model.strings.imgfilename;   
struct_record.user = model.strings.username;

if model.struct.down.ispeak == 1
    struct_record.peak = 1;
    struct_record.r = model.struct.down.r;
    struct_record.c = model.struct.down.c;
else
    struct_record.peak = 0;
    struct_record.r = model.struct.up.r;
    struct_record.c = model.struct.up.c;
end

Records = load(model.strings.resultsfilename);
Records = Records.Records;
ilength = length(Records);
Records(ilength + 1).peak = struct_record.peak;
Records(ilength + 1).r = struct_record.r;
Records(ilength + 1).c = struct_record.c;
Records(ilength + 1).user = struct_record.user;
Records(ilength + 1).img = struct_record.img;
save(model.strings.resultsfilename, 'Records');

loadnext();    

end

function loadnext()

    global model;
       
    % ... Now let the user perform the forced choice experiments.
    [struct_H, struct_L] = twoafc_SingleView(model.struct.data);
    
    if model.nums.samplescounter >= model.nums.samples
        disableAllControls(handles);
        return
    end
    
    % Flip the data if required
    if rand > 0.5
        if model.flag.debug == 1; disp('UP'); end;
        model.struct.up = struct_H;
        model.struct.down = struct_L;
    else
        if model.flag.debug == 1; disp('DOWN'); end;
        model.struct.up = struct_L;
        model.struct.down = struct_H;
    end
    
    update_Tab2_MainAxes();  % replaces updateMainScreen(handles);
    update_Tab2_MinorAxes(); % replaces updatescreens(handles);

end

function disableAllControls(handles)

global view;

set(view.tab2.edit_file,'String','');
set(view.tab2.button_green,'Enable','off');
set(view.tab2.button_red,'Enable','off');
msgbox('Session finsihed for this image, please select another image','modal');

% Insert code here to flush or clear the model.
create_Model(); % Resets the model to its original value

end

function increment_Counter()
    global model;
    global view;
    model.nums.samplescounter = model.nums.samplescounter + 1;
    set(view.tab2.text_progress, 'string', ['Image ' num2str(model.nums.samplescounter) ' of ' num2str(model.nums.samples)]);
end

function update_Counter()
    global model;
    global view;
    set(view.tab2.text_progress, 'string', ['Image ' num2str(model.nums.samplescounter) ' of ' num2str(model.nums.samples)]);
end




