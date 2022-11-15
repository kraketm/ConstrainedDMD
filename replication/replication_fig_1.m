%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Constrained Dynamic Mode Decomposition %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This file replicates Fig. 1 (artificial dataset) of the manuscript 
% 'Constrained Dynamic Mode Decomposition'. It is based on an univariate 
% time series that consists of four different patterns:
% - linear trend, 
% - seasonal pattern with period 7 
% - seasonal pattern with period 28
% - noise with approximately 5%
% Therefore, the time series describes typical daily data.

clear; close; clc;
addpath('../toolbox/', '../datasets/', '../figures/')


%% Input
DATA = IO_LoadData('artificial');                       % load artificial dataset


%% Original DMD
DMDOrig = DMD_ConstrainedDMD(DATA);                     % compute original DMD (Algorithm 1, line 1-7)
DMDOrig = DMD_InfluenceComputation(DATA, DMDOrig);      % compute influence of DMD components (Eq. 20)
DMDOrig = VIS_Filtering(DMDOrig, 1e-3, 1e-2);           % use filtering technique
          

%% Constrained DMD - human-in-the-loop feedback
periods = [7; 28];
constrs = [exp(2*pi*1i./(periods)); conj(exp(2*pi*1i./(periods)))];
DMDCons = DMD_ConstrainedDMD(DATA, DMDOrig, constrs);   % compute constrained DMD (Algorithm 1, line 8-18)
DMDCons = DMD_InfluenceComputation(DATA, DMDCons);      % compute influence of DMD components (Eq. 20)
DMDCons = VIS_Filtering(DMDCons, 1e-3, 1e-2);           % use filtering technique


%% Replication of Fig. 1
TeaserPlot(DATA, DMDOrig, DMDCons)                      % visualize and compare DMD components
