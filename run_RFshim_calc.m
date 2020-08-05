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
%%
% Script to run the calibration-free shim calculation on database of B1+
% maps. Requires complex B1+ maps and ROI definitions (registered to each B1+ map
% Preprint: https://doi.org/10.1101/2020.07.24.20161141

roiName         = 'hippo';          % occ, pcc, brain
methodName      = 'minTargetAmp';   % the shimming method

dsadjust        = 1.2;              % adjust B1-map in quad mode to scale total power of solution           

[w, dist]       = calc_calibfree_shims(roiName, methodName, dsadjust);
