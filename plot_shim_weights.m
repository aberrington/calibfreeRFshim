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

function f= plot_shim_weights(w)

% function to plot the amplitude and phases of the transmit elements
% following RF shimming

% INPUTS:   w - complex shim weights
% OUTPUTS:  f - figure handle

% choose colormap
cmap = jet(8);

% plot on Argand Diagram
f = figure('Name', 'Calibration-free shim');

for c =1:8
    polarplot(w(c), 'o', 'MarkerFaceColor', cmap(c,:), 'Color', 'none')
    pax = gca;
    pax.GridLineStyle = ':';
    hold on
end
pax.RLim = [0 2.5];
thetaticks(pax, 0:30:330);
cnt = 1;
for c = 0:30:330
    thetanames{cnt} = [num2str(c) char(176)];
    cnt = cnt+1;
end
thetaticklabels(pax, thetanames);
title('calibration-free shim');
set(gca, 'FontName', 'Arial')
hleg = legend('1', '2','3','4','5','6','7','8');
title(hleg, 'Channel');
hold off

end

