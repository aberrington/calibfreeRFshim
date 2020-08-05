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

function [] = plot_B1maps(B, M, slice, ROI)
% function to plot the B1maps in an image vector

% INPUTS:   B - B1+ maps
%           M - mask
%           slice - for display
%           ROI - ROI definition

% Initialisations
s       = slice;
topRow  = [];
roi     =[];
for n = 1:size(B,4)   
    topRow  = cat(2,topRow,squeeze(double(M(:,:,s,n)).*abs(B(:,:,s,n))));
    roi     = cat(2,roi,squeeze(abs(ROI(:,:,s,n))));
end

imagesc(topRow);
colormap jet
hold on
h=imagesc(roi, 'CData', cat(3, ones(size(roi)),ones(size(roi)),ones(size(roi))));
alphamask = [0.9]*roi;
set(h, 'AlphaData', alphamask);
caxis([0, 1.5])
colormap jet
colorbar

end

