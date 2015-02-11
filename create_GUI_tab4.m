function [ output_args ] = create_GUI_tab4 ( settings, hTabGroup )

global view;
global model;

tab4 = uitab(hTabGroup, 'title','Data Export');                     % create the tab title
position = view.position(4,:);  

ui_text1 = uicontrol(tab4, 'Style', 'pushbutton', 'String', 'Export Data',...
    'Position', [120 200 150 25],'HorizontalAlignment','left', 'Callback', @execute_export);

end

function execute_export(source, callbackdata)

    global model;
    global view;
    % Here comes the code for exporting the data to a csv file
    % underneath I will list the data to be exported 
    % img spot.r spot.c 5_features 49_pixel_values num_annotations percentage_foreground class list_user_annotation
    
    % Filename
    filename = [datestr(datetime) '.txt'];
    filename = strrep(filename, ':', '');
    filename = strrep(filename, '-', '');
    fid = fopen(filename,'w');
    
    % First get the image, user and threshold
    [img, users, threshold] = get_img_users_threshold ();
    
    % Now acquire the spot positions and the five features and start writing to the file
    % - The best way to do that would be through a for loop which loops over every spot in the image file
    %
    %
    % For writing use the following convention
    % - for the first line          dlmwrite('test.txt', [1 2 3], 'newline', 'pc');
    % - for the next lines          dlmwrite('test.txt', [1 2 3], '-append', 'newline', 'pc');
    
    for k = 1:1 %length(model.tab3.data_Master_Complete)
            
        fprintf(fid,'%s,', img);                                                % write image name
        fprintf(fid,'%d,', model.tab3.data_Master_Complete(k).r);               % write spot.r
        fprintf(fid,'%d,', model.tab3.data_Master_Complete(k).c);               % write spot.c
        
        fprintf(fid,'%.2f,', model.tab3.data_Master_Complete(k).peak);            % write feature1
        fprintf(fid,'%.2f,', model.tab3.data_Master_Complete(k).sigma);           % write f2
        fprintf(fid,'%.2f,', model.tab3.data_Master_Complete(k).std);             % write f3
        fprintf(fid,'%.2f,', model.tab3.data_Master_Complete(k).uncertainty);     % write f4
        fprintf(fid,'%.2f,', model.tab3.data_Master_Complete(k).intensity);       % write f5
        
        % write the 49 pixel values
        Image = imread([model.strings.imgfilepath view.tab3.dropdown_imgs.String{view.tab3.dropdown_imgs.Value}]);
        for r = -4:1:4
            for c = -4:1:4
            
            value = Image(model.tab3.data_Master_Complete(k).r + r, model.tab3.data_Master_Complete(k).c + c);
            fprintf(fid,'%d,', value); 
                
            end
        end
        
        % write the remaining values
        
        % write next line
    
    end
    
    close(fid);
end

function [img, users, threshold] = get_img_users_threshold ()

    global model;
    global view;
    
    img = model.tab3.data_Master_Complete(1).img; % Got the image
    
    if view.tab3.dropdown_users.Value == 1 % Got the users
        users = 'ALL';
    else
        users = view.tab3.dropdown_users.String(view.tab3.dropdown_users.Value);
    end
    
    base = 20; % Got the threshold
    threshold = 0;
    
    if model.tab3.dropdown_fg.Value == 1
        % do nothing
    else
        threshold = base + model.tab3.dropdown_fg.Value * 10;
    end

end

