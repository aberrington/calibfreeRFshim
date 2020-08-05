%  Copyright [2020] [Adam Berrington]
% 
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
% 
%        http://www.apache.org/licenses/LICENSE-2.0
% 
%    Unless required by applicable law or agreed to in writing, software
%    distributed under the License is distributed on an "AS IS" BASIS,
%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%    See the License for the specific language governing permissions and
%    limitations under the License.
function [w, dist] = calc_calibfree_shims(shimROI, shimMethod, dsadjust)
% INPUTS:   shimROI (occ,hippo,pcc,brain)
%           shimMethod (minTargetAmp)
%           sliceN 30 - for display
%           dsadjust - adjust the scaling of the quadrature B1+ maps to control
%           overall power
% OUTPUTS:  w - the complex shim vector
%           dist - statistics about the distribution of the shim solution

% Initialisations

if(nargin<3)
    dsadjust    =   1.2; % Setting used for calib-free shim manuscript
end

sliceN = 30;

% Load database information 
load('database/B1_per_channel.mat', 'B'); % 8x64x64x57x11 matrix of complex B1 maps in database
load('database/brain_mask.mat', 'mask'); %
load('database/ROI.mat','ROI'); %

B           =   B/dsadjust; % adjust for fixed power limits

switch(shimROI)
    case 'brain'
        ROImask     =   mask;
    case 'occ'
        ROImask     =   squeeze(ROI(:,:,:,1,:));
    case 'hippo'
        ROImask     =   squeeze(ROI(:,:,:,2,:));
    case 'pcc'
        ROImask     =   squeeze(ROI(:,:,:,3,:));
end

[w, dist] = calc_database(B,ROImask,shimMethod);

% plot the predicted shim set here
% want to plot the shim settings for the 

Bshim       = calc_predicted_shim(B,w);
figure
plot_B1maps(Bshim, mask, sliceN, ROI)
title('database shim');
axis equal

plot_shim_weights(w);