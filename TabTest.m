% Tab test file
function TabTest ()

clearvars
close all
clc

% perform all initializations in this block and create the GUIs
initialize_Application();

create_Model();
create_View();

settings = initialize_Settings();       % initialize the settings
hTabGroup = create_GUI(settings);       % create the GUI
initialize_GUI(hTabGroup);              % initialize the GUI
initialize_LookAndFeel();               % initialize the look and feel

% actual start of the application
end




