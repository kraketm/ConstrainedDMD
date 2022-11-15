%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Constrained Dynamic Mode Decomposition %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This file replicates Fig. 10 (energy consumption dataset) of the 
% manuscript 'Constrained Dynamic Mode Decomposition'. It is based on an
% hourly multivariate time series that consists of three attributes:
% - energy consumption of San diego (in MWh)
% - dry bulb temperature (in Fahrenheit)
% - installed capacity of solar panels at customer sites (in kW)
% The time series mainly focus on San diego's energy consumption, however, 
% the other attributes are highly correlated.  

clear; close; clc;
addpath('../toolbox/', '../datasets/')


%% Input
DATA = IO_LoadData('energy_consumption');                       % load energy consumption dataset


%% Original DMD
DMDOrig = DMD_ConstrainedDMD(DATA);                     % compute original DMD (Algorithm 1, line 1-7)
DMDOrig = DMD_InfluenceComputation(DATA, DMDOrig);      % compute influence of DMD components (Eq. 20)
DMDOrig = VIS_Filtering(DMDOrig, 1e-3, 1e-2);           % use filtering technique


%% Constrained DMD - human-in-the-loop feedback
periods = [24; 12; 168; 84];
constrs = [exp(2*pi*1i./(periods)); conj(exp(2*pi*1i./(periods)))];
DMDCons = DMD_ConstrainedDMD(DATA, DMDOrig, constrs);   % compute constrained DMD (Algorithm 1, line 8-18)
DMDCons = DMD_InfluenceComputation(DATA, DMDCons);      % compute influence of DMD components (Eq. 20)
DMDCons = VIS_Filtering(DMDCons, 1e-3, 1e-2);           % use filtering technique


%% Replication of Fig. 10
MultiPlot(DATA, DMDOrig, DMDCons)
