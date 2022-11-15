%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Constrained Dynamic Mode Decomposition %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the main demo for 'Constrained Dynamic Mode Decomposition'.
%
% 
% The demo uses the lynx dataset (compare Figure 7, 8, and 9). It is an 
% univariate time series that consists of seasonal and cyclic patterns.
% These patterns are characterized by a non-integer period given by 9.63.
% Therefore, the time series describes no typical time-scale.

clear; close; clc;
addpath('toolbox/')


%% Input
DATA = IO_LoadData('lynx');                             % load lynx dataset


%% Original DMD
DMDOrig = DMD_ConstrainedDMD(DATA);                     % compute original DMD (Algorithm 1, line 1-7)
DMDOrig = DMD_InfluenceComputation(DATA, DMDOrig);      % compute influence of DMD components (Eq. 20)
DMDOrig = VIS_Filtering(DMDOrig, 1e-3, 5e-2);           % use filtering technique 

VIS_OverviewRepresentation(DATA, DMDOrig, 6)            % visualize DMD components (Fig. 7, 3rd column)


%% Constrained DMD - 1. human-in-the-loop feedback
periods1 = [9.63, 9.63/2]';
constrs1 = [exp(2*pi*1i./(periods1)); conj(exp(2*pi*1i./(periods1)))];
DMDCons1 = DMD_ConstrainedDMD(DATA, DMDOrig, constrs1); % compute constrained DMD (Algorithm 1, line 8-18)
DMDCons1 = DMD_InfluenceComputation(DATA, DMDCons1);    % compute influence of DMD components (Eq. 20)
DMDCons1 = VIS_Filtering(DMDCons1, 1e-3, 5e-2);         % use filtering technique 

VIS_OverviewRepresentation(DATA, DMDCons1,6)            % visualize DMD components (Fig. 8)
VIS_ChangeTracking(DMDOrig, DMDCons1)                   % change tracking of eigenvalues (Fig. 9, left)


%% Constrained DMD - 2. human-in-the-loop feedback
periods2 = [9.63, 9.63/2, 9.63*4, 9.63*2]';
constrs2 = [exp(2*pi*1i./(periods2)); conj(exp(2*pi*1i./(periods2)))];
DMDCons2 = DMD_ConstrainedDMD(DATA, DMDOrig, constrs2); % compute constrained DMD (Algorithm 1, line 8-18)
DMDCons2 = DMD_InfluenceComputation(DATA, DMDCons2);    % compute influence of DMD components (Eq. 20)
DMDCons2 = VIS_Filtering(DMDCons2, 1e-3, 5e-2);         % use filtering technique 

VIS_OverviewRepresentation(DATA, DMDCons2,6)            % visualize DMD components (Fig. 7, 4th column)
VIS_ChangeTracking(DMDCons1, DMDCons2)                  % change tracking of eigenvalues (Fig. 9, right)
