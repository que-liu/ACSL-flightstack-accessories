% %% PyChrono Wrapper PLOTTER
% clear; clc; close all;
% 
% %% 
% % Define global propertries
% % Set overall properties for plots and figures
% set(groot, 'defaultAxesTickLabelInterpreter','latex');
% set(groot, 'defaultLegendInterpreter','latex');
% set(groot, 'defaultAxesFontSize', 20);
% 
% % Generate a path string including all subdirectories of plot_functions
% addpath(genpath('.\plot_functions'));
% addpath(genpath('.\pychrono'));
% 
% % Plot properties
% pp.font_size = 20;
% pp.font_size_title = 22;
% 
% pp.x_lim_min = 0;
% % pp.x_lim_min = 10;
% pp.x_lim_max = 23.5;
% % pp.x_lim_max = log.time(end);
% 
% % =========================================================================
% % Choose folder where wrapper workspace logs are stored
% start_path = fullfile(pwd, '..', 'pychrono', 'wrapper');
% wrapper_folder = uigetdir(start_path, 'Select Wrapper "workspaces" Folder');
% if wrapper_folder == 0
%     error('No folder selected.');
% end
% 
% % Set the field to sort workspaces by (e.g., ball density)
% sort_field = 'sim_cfg.wrapper_params.my_ball_density';
% 
% % Load and sort all workspace files in the batch
% fprintf("Loading wrapper batch from: %s\n", wrapper_folder);
% workspaces = loadSortedWorkspacesByField(wrapper_folder, sort_field);
% 
% % Example usage: loop through and prepare for plotting
% for i = 1:length(workspaces)
%     fprintf("\n Workspace [%d/%d] — %s\n", i, length(workspaces), workspaces(i).filename);
% 
%     % Extract log, sim_cfg, gains, etc.
%     log     = workspaces(i).log;
%     sim_cfg = workspaces(i).sim_cfg;
%     gains   = workspaces(i).gains;
% 
%     % Compute derived values from log
%     der = PyC_computeDerivedValues(log);
%     workspaces(i).der = der;
% 
%     pp.folder_controller = sim_cfg.mission_config.controller_type;
% 
%     if (pp.folder_controller == "PID")
%         der = PyC_computeDerivedValues_PID(log, der);
%     elseif (pp.folder_controller == "MRAC") || ...
%            (pp.folder_controller == "NonAdaptiveEBCI") || ...
%            (pp.folder_controller == "TwoLayerMRAC") || ...
%            (pp.folder_controller == "HybridMRAC") || ...
%            (pp.folder_controller == "HybridTwoLayerMRAC")
%         der = PyC_computeDerivedValues_MRAC(log, der);
%     elseif (pp.folder_controller == "FunnelMRAC")
%         der = PyC_computeDerivedValues_FunMRAC(log, der, gains);
%     end
% 
%     % Optionally: save or display sort key
%     sort_value = workspaces(i).sort_key;
%     fprintf("   Sorted value (%s): %.4f\n", sort_field, sort_value);
% 
%     % Your plotting or analysis function here
%     % Example:
%     % plotPosition(log, der, pp);
% end


%% PyChrono Wrapper PLOTTER
clear; clc; close all;

%% =========================================================================
% Choose folder where wrapper workspace logs are stored
start_path = fullfile(pwd, '..', 'pychrono', 'wrapper');
wrapper_folder = uigetdir(start_path, 'Select Wrapper "workspaces" Folder');
if wrapper_folder == 0
    error('No folder selected.');
end

fprintf("Loading all .mat workspaces from: %s\n", wrapper_folder);

% List all .mat files in the selected folder
files = dir(fullfile(wrapper_folder, '*.mat'));
nFiles = length(files);

if nFiles == 0
    error('No .mat workspace files found in the selected folder.');
end

workspaces = struct([]);

% Load and compute derived values
for i = 1:nFiles
    fname = fullfile(wrapper_folder, files(i).name);
    fprintf("\n Loading [%d/%d] — %s\n", i, nFiles, files(i).name);

    tmp = load(fname);

    % Extract fields
    log     = tmp.log;
    sim_cfg = tmp.sim_cfg;
    gains   = tmp.gains;

    % Compute derived values (MRAC)
    der = struct();
    der = PyC_computeDerivedValues_MRAC(log, der);

    % Store everything
    workspaces(i).filename = files(i).name;
    workspaces(i).log      = log;
    workspaces(i).sim_cfg  = sim_cfg;
    workspaces(i).gains    = gains;
    workspaces(i).der      = der;

    % Sorting key = final L2 tracking error
    workspaces(i).sort_key = der.outer_loop.tracking_error_L2norm(end);
end

% Sort by the final L2 norm tracking error
[~, idx] = sort([workspaces.sort_key]);  % ascending = best first
workspaces = workspaces(idx);
