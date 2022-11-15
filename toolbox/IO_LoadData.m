function [DATA] = IO_LoadData(dataset)
% This function IO_LoadData generates the input data for Constrained 
% Dynamic Mode Decomposition. It includes three different time series:
% * artificial dataset          - univariate time series
% * lynx dataset                - univariate time series
% * energy consumption dataset  - multivariate time series
%
%
% [DATA] = IO_LoadData(dataset)
%
% Input: A string for a previously mentioned dataset
%   * dataset --> use "artifical", "lynx", or "energy_consumption"
%
% Output: Data container DATA with the following properties
%   * DATA.type
%   * DATA.timeSeries   
%   * DATA.N
%   * DATA.M
%   * DATA.delayParameter
%   * DATA.delayedTimeSeries
%   * DATA.n
%   * DATA.m


fprintf('Loading %s dataset ... ',dataset)

if(dataset == "artificial")
    
    DATA.type = "univariate";

    % Definition of artificial dataset (nondeterministic due to noise)
    % DATA.timeSeries = zeros(1,51);
    % DATA.timeSeries = DATA.timeSeries + 2*(1:length(DATA.timeSeries)) + 50*ones(size(DATA.timeSeries));     % trend
    % DATA.timeSeries = DATA.timeSeries + 08*sin(2*pi*(0:size(DATA.timeSeries,2)-1)/07);                      % seasonal pattern - period 7
    % DATA.timeSeries = DATA.timeSeries + 20*sin(2*pi*(0:size(DATA.timeSeries,2)-1)/28);                      % seasonal pattern - period 28
    % DATA.timeSeries = DATA.timeSeries + 5*(2*(rand(size(DATA.timeSeries))-0.5));                            % noise
    
    % Loading artificial dataset for replicability
    load('datasets/artificial.mat','timeSeries')
    DATA.timeSeries = timeSeries;

    % Parameter of delayed time series
    DATA.delayParameter = 40;


elseif(dataset == "lynx")

    DATA.type = "univariate";

    % Loading lynx dataset
    load('datasets/lynx.mat','timeSeries')
    DATA.timeSeries = timeSeries(end-69:end);

    % Parameter of delayed time series
    DATA.delayParameter = 41;
    

elseif(dataset == "energy_consumption")

    DATA.type = "multivariate";

    % Loading energy consumption dataset
    T = readtable('datasets/hourly_data.txt');
    DATA.timeSeries(1,:) = T.HourlyDryBulbTemperature(40585:40585+336)';
    DATA.timeSeries(2,:) = T.AC_kW(40585:40585+336)';
    DATA.timeSeries(3,:) = T.SDGE(40585:40585+336)';

    % Parameter of delayed time series
    DATA.delayParameter = 203;

    % Additional scaling for the influence of DMD components
    DATA.scalingDiag = [1/6 1/6 4/6];
    

end


% Generation of delayed time series
DATA.delayedTimeSeries = TOOL_HankelShift(DATA.timeSeries, DATA.delayParameter);

% Dimensions of the time series and delayed time series
[DATA.N, DATA.M] = size(DATA.timeSeries);
DATA.M = DATA.M - 1;
[DATA.n, DATA.m] = size(DATA.delayedTimeSeries);
DATA.m = DATA.m - 1;


fprintf('done \n\n')


end