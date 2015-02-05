function [ output_args ] = create_GUI_tab3 ( settings, hTabGroup )

global view;
global model;

tab3 = uitab(hTabGroup, 'title','Results');                     % create the tab title
position = view.position(3,:);                                  % read the position at index 3 

tab1_X_offset = 50;
tab1_Y_offset = 50;

ui_text = uicontrol(tab3, 'Style', 'text', 'String', 'Specify file name',...
    'Position', [100 430 150 25],'HorizontalAlignment','left');
ui_edit_text = uicontrol(tab3, 'Style', 'edit',...
    'Position', [240 430 200 25],'HorizontalAlignment','left');


% % code for adding the three controls and registering them in the view. ui_text = uicontrol(tab3, 'Style', 'text', 'String',
% 'Specify file name','Position', [50 position(4)-100 settings.active.popup_lengthX+50
% settings.active.popup_lengthY],'HorizontalAlignment','left'); ui_edit = uicontrol(tab3, 'Style', 'edit','Position', [270
% position(4)-100 settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left'); ui_button =
% uicontrol(tab3, 'Style', 'pushbutton', 'String', 'Specify file name','Position', [270 position(4)-130
% settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','left', 'Callback', @select_DataFile);
% 
% view.tab3.edit_file = ui_edit; view.tab3.button_select = ui_button;
% 
% % code for adding the drop down ui_text = uicontrol(tab3, 'Style', 'text', 'String', 'Select signals for
% display','Position', [50 position(4)-170 settings.active.popup_lengthX
% settings.active.popup_lengthY],'HorizontalAlignment','left'); ui_popup = uicontrol(tab3, 'Style', 'popup', 'String', {'
% ','All signals','Only annotated spots'}, 'Position', [270 position(4)-170 settings.active.popup_lengthX
% settings.active.popup_lengthY],'HorizontalAlignment','left'); view.tab3.popup_mode = ui_popup;
% 
% % code for adding the drop down for specifying the foreground-background threshold. ui_text = uicontrol(tab3, 'Style',
% 'text', 'String', 'Select foreground threshold (%)','Position', [50 position(4)-230 settings.active.popup_lengthX+50
% settings.active.popup_lengthY],'HorizontalAlignment','left'); ui_popup = uicontrol(tab3, 'Style', 'popup', 'String', {'
% ','0.5','0.6','0.7','0.8'}, 'Position', [270 position(4)-230 settings.active.popup_lengthX
% settings.active.popup_lengthY],'HorizontalAlignment','left','Callback', @update_Threshold); view.tab3.popup_threshold =
% ui_popup;
% 
% ui_text = uicontrol(tab3, 'Style', 'radiobutton', 'String', 'Link displays','Position', [270 position(4)-260
% settings.active.popup_lengthX settings.active.popup_lengthY],'HorizontalAlignment','right','Callback', @link_Displays);
% view.tab3.radio_displays = ui_text;
% 
% % code for adding the two pannels p1 = uipanel(tab3, 'Title', 'Before annotation','Position', [.03 .03 .45 .65]); p2 =
% uipanel(tab3, 'Title', 'After annotation','Position', [.49 .03 .45 .65]); view.tab3.panel_before = p1;
% view.tab3.panel_after = p2;
% 
% % code for adding the four axes to the panels. % the first two axes display the spots before and after the manual
% annotation % The next two axes display the spots before and after the manual annotation displayed on the image itself a1  =
% axes('Parent', p1, 'Position',  [.30 .05 0.65 0.9], 'Box', 'off'); hold on; if model.flag.debug == 0; axis off; end; a11 =
% axes('Parent', p1, 'Position',  [.02 .05 0.26 0.9], 'Box', 'off'); hold on; if model.flag.debug == 0; axis off; end;
% 
% a2  = axes('Parent', p2, 'Position',  [.30 .05 0.65 0.9], 'Box', 'off'); hold on; if model.flag.debug == 0; axis off; end;
% a22 = axes('Parent', p2, 'Position',  [.02 .05 0.26 0.9], 'Box', 'off'); hold on; if model.flag.debug == 0; axis off; end;
% 
% % register the axes to the view.tab3 view.tab3.axis_before_image     =   a1; view.tab3.axis_before_spots     =   a11;
% view.tab3.axis_after_image      =   a2; view.tab3.axis_after_spots      =   a22;
% 
% set(view.tab3.popup_threshold,'Value',3); set(view.tab3.popup_mode,'Value',3);

end

% Here are the old functions which may or may not be useful

function select_DataFile(hObject, event, handles)

    global model;
    global view;
    
    [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.png');
    model.tab3.strings.imgfilename = FILENAME;
    model.tab3.strings.imgfilepath = PATHNAME;

    model.tab3.image.input = imread([model.tab3.strings.imgfilepath model.tab3.strings.imgfilename]);
    set(view.tab3.edit_file,'String',[model.tab3.strings.imgfilename]);
    
    tempfilename = model.tab3.strings.imgfilename(1:end-4);
    model.tab3.struct.f_data = csvread([ model.tab3.strings.imgfilepath tempfilename '.csv'], 1, 0);
    
    % code comes here for loading all the data and making it work.
    %
    % this is important - there are multiple things which need to be done
    % one - load the image, already done in the line above
    % two - load the original data from the 'thunder storm' already done above
    % third - load the data from the results file, augmented to the data file if required.

    load_BeforeAnnotationData();
    load_AfterAnnotationData();
    
end

function load_BeforeAnnotationData ()

    global model;
    global view;
    
    % show the image in both the axes.
    imshow(model.tab3.image.input, 'Parent', view.tab3.axis_before_image);
    zoom on;
    
    % load the datapoints from the file
    Data = [];
    for k = 1:size(model.tab3.struct.f_data,1) 
        Data(k).peak = model.tab3.struct.f_data(k,4); 
        Data(k).r = round(model.tab3.struct.f_data(k,2)); 
        Data(k).c = round(model.tab3.struct.f_data(k,1)); 
    end
    
    Data = nestedSortStruct(Data, 'peak');
    limit = round(length(Data) * model.nums.background_ratio);
    Data = fliplr(Data);
    
    fgspots = Data(1:length(Data)-limit);
    bgspots = Data((length(Data)-limit)+1:end);
    assert(length([fgspots bgspots]) == length(Data), 'Assertion failed in load_BeforeAnnotationData');
    
    axes(view.tab3.axis_before_image); hold on;
    for i = 1:length(fgspots)
        plot(fgspots(i).c, fgspots(i).r, 'r.');
    end
    for i = 1:length(bgspots)
        plot(bgspots(i).c, bgspots(i).r, 'g.');
    end
    
    gridimg_before_annotation = createGridImage(fgspots, bgspots, model.tab3.image.input);
    imshow(gridimg_before_annotation, [0 max(gridimg_before_annotation(:)) ], 'Parent', view.tab3.axis_before_spots, 'InitialMagnification', 'fit');

end

function [gridimg] = createGridImage (fgspots, bgspots, img_data)

    % img_data - Actual image on from which the spot cutouts are to be taken.  
    % fgspots - A list of r,c tuples for foreground spots in order of decreasing 'spottiness'.
    % bgspots - A list of r,c tuples for background spots in order of decreasing 'spottiness'.

    global model;

    grid_cols = 8;
    grid_spacing = 5;
    spotsize = 9;

    % sort on photon count in descending order.
    csv_data_peak = fgspots; num_peaks = length(csv_data_peak);
    csv_data_bkgd = bgspots;

    % first plot the foreground spots.
    num_rows = ceil(num_peaks/grid_cols);
    Image = [];
    counter = 1;
for i = 1:num_rows;
    
    Row = zeros(spotsize, spotsize*grid_cols + grid_spacing*(grid_cols-1));
    for j = 1:grid_cols
        
        patch = img_data(round(csv_data_peak(counter).r)-4:round(csv_data_peak(counter).r)+4, round(csv_data_peak(counter).c)-4:round(csv_data_peak(counter).c)+4);
        Row(:,((j-1)*spotsize)+((j-1)*grid_spacing)+1:  ((j-1)*spotsize)+((j-1)*grid_spacing)+spotsize) = patch;
        counter = counter + 1;
        
        if counter >= num_peaks; break; end;
        
    end
    Image = [Image; Row];
    Image = [Image; zeros(grid_spacing, spotsize*grid_cols + grid_spacing*(grid_cols-1))];
    
end

% Insert vertical spacing
Image = [Image; zeros(grid_spacing*2, spotsize*grid_cols + grid_spacing*(grid_cols-1))];    

% now plot the background spots
num_peaks = length(csv_data_bkgd);
num_rows = ceil(num_peaks/grid_cols);
counter = 1;
for i = 1:num_rows;
    
    Row = zeros(spotsize, spotsize*grid_cols + grid_spacing*(grid_cols-1));
    for j = 1:grid_cols
        
        patch = img_data(round(csv_data_bkgd(counter).r)-4:round(csv_data_bkgd(counter).r)+4, round(csv_data_bkgd(counter).c)-4:round(csv_data_bkgd(counter).c)+4);
        Row(:,((j-1)*spotsize)+((j-1)*grid_spacing)+1:  ((j-1)*spotsize)+((j-1)*grid_spacing)+spotsize) = patch;
        counter = counter + 1;
        
        if counter >= num_peaks; break; end;
        
    end
    Image = [Image; Row];
    Image = [Image; zeros(grid_spacing, spotsize*grid_cols + grid_spacing*(grid_cols-1))];
    
end

Image = [Image; zeros(grid_spacing-4, spotsize*grid_cols + grid_spacing*(grid_cols-1))];    

gridimg = Image;

end

function load_AfterAnnotationData ()

    global view;
    global model;

    display_mode = get(view.tab3.popup_mode,'Value');
    peak_threshold = get(view.tab3.popup_threshold,'Value');
    peak_threshold = model.tab3.threshold_values(peak_threshold);
    peak_threshold = cell2mat(peak_threshold);
    disp(['Peak threshold ' num2str(peak_threshold)]);
    
    if display_mode == 2    
        % case where all the signals are to be displayed.
        
    elseif display_mode == 3
        % case where only the graded signals are to be shown
        % load the data from Results.mat
        Records = load(model.strings.resultsfilename);
        Records = Records.Records;
        
        % Find the data which belong to the current image.
        struct_data = [];
        for i = 1:length(Records)
            if strcmp(Records(i).img, model.tab3.strings.imgfilename);
                struct_data = [struct_data Records(i)];
            end
        end
        
        % display the +ve peak data and display the -ve peak data.
        i = 1;
        while i <= length(struct_data)
            totalcount = 0;
            positcount = 0;
            negatcount = 0;
            j = 1;
            while j <= length(struct_data)
            	if struct_data(i).r == struct_data(j).r && struct_data(i).c == struct_data(j).c  
                    totalcount = totalcount + 1;
                    if struct_data(j).peak == 1
                        positcount = positcount + 1;
                    else
                        negatcount = negatcount + 1;
                    end
                    if i ~= j
                        struct_data(j) = [];
                    end
                end
                j = j + 1;
            end
            struct_data(i).posit = positcount;
            struct_data(i).total = totalcount;
            i = i+1;
        end
        
        imshow(model.tab3.image.input, 'Parent', view.tab3.axis_after_image);
        axes(view.tab3.axis_after_image); 
        
        % create the empty struct lists for holding the foreground and background spots.
        fgspots = [];
        bgspots = [];
        
        hold on;
        for i = 1:length(struct_data)
            if struct_data(i).posit/struct_data(i).total >= peak_threshold
                plot(struct_data(i).c, struct_data(i).r, 'r.')
                fgspots(i).r = struct_data(i).r;
                fgspots(i).c = struct_data(i).c;
            else
                plot(struct_data(i).c, struct_data(i).r, 'g.')
                bgspots(i).r = struct_data(i).r;
                bgspots(i).c = struct_data(i).c;
            end
        end
        
        empty_elems = arrayfun(@(s) isempty(s.r) & isempty(s.c), fgspots);
        fgspots(empty_elems) = [];
        
        empty_elems = arrayfun(@(s) isempty(s.r) & isempty(s.c), bgspots);
        bgspots(empty_elems) = [];
        
        gridimg_after_annotation = createGridImage(fgspots, bgspots, model.tab3.image.input);
        imshow(gridimg_after_annotation, [0 max(gridimg_after_annotation(:)) ], 'Parent', view.tab3.axis_after_spots, 'InitialMagnification', 'fit');
        
    else
        assert(8==9, 'Data selection mode on tab3 not properly set');
    end
    
    

end

function link_Displays(hObject, event, handles)

    global view;
    if get(view.tab3.radio_displays, 'Value')
        disp('on');
        linkaxes([view.tab3.axis_before_image view.tab3.axis_after_image], 'xy');
    else
        disp('off');
        linkaxes([view.tab3.axis_before_image view.tab3.axis_after_image], 'off');
    end

end

function update_Threshold (hObject, event, handles)

    global view;
    global model;
    
    peak_threshold = get(view.tab3.popup_threshold,'Value');
    peak_threshold = model.tab3.threshold_values(peak_threshold);
    peak_threshold = cell2mat(peak_threshold);
    
    if ~isnan(peak_threshold)
        load_AfterAnnotationData();
    end

end

% End of the old functions





