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
% 
%    Original code from: Christopher J. Mirfin
%    Sir Peter Mansfield Imaging Centre, Nottingham, UK
%    christopher.mirfin@nottingham.ac.uk
%    24/10/2016
function [w, dist] = calc_database(B,ROI,method) 

[Nc,m,n,numSlices,numSubjects] = size(B); % Nc = number of Tx coils, (m,n) = slice dimensions

for n =1:numSubjects
    b       = squeeze(B(:,:,:,:,n));
    S{n}    = b(:,ROI(:,:,:,n) == 1)'; % sensitivity matrix NROI x 8
end

% default drive

phi = (pi/180)*[0, 315, 270, 225, 180, 135, 90, 45];
w0 = ones(1,8);

options = optimset('MaxIter', 10000,'MaxFunEvals',10000, 'Display', 'off');

switch method
    
    case 'No shim'
        w = w0';
    
     case 'minTarget'
        params0 = phi;
        %params0(end+1) = 1; % this is the target B1
        [params,~] = fminsearch(@(params)(costMinTarget(params(:),S)),params0,options);
        params = -params;
        w = exp(1i*params);
        %w = conj(w);

      case 'minTargetAbs'
        params0 = phi;
        %params0(end+1) = 1; % this is the target B1
        [params,~] = fminsearch(@(params)(costMinTargetAbs(params(:),S)),params0,options);
        params = -params;
        w = exp(1i*params);
        %w = conj(w);
        
    case 'minTargetAmp'
        params0(1:8) = ones(8,1);
        params0(9:16) = phi;
        %params0(9:16) = fminsearch(@(params)(costMinTarget(params(:),S)),params0,options);
        %params0(1:8) = ones(8,1);
        lb = [zeros(8,1); -1 * Inf(8,1)]; % set the lower bound to the solution - amplitudes should be < 1 and > 0
        ub = [ones(8,1); Inf(8,1)];
        [params, fval] = fmincon(@(params)(costMinTargetAmp(params(:),S)),params0,[],[],[],[],[], [],@limit_channel_RF_norm,options);
        %[params,fval] = fminsearch(@(params)(costMinTargetAmp(params(:),S)),params0,options);
        %params = -params;
        w = params(1:8).*exp(-1i*params(9:16));
        
end


% normalise weights
 %w = w./max(abs(w));
 
 for n = 1:numSubjects
    dist.RMSE(n) = sqrt(mean((abs(S{n}*w')-1).^2));
    dist.mu(n)  = mean(abs(S{n}*w'));
    dist.std(n) = std(abs(S{n}*w'));
 end

 
end

function  costs = costMinTarget(params,S)
    N = length(S);
    w = exp(1i*params(1:8));
    T = 1; % this is the goal
    %w = params(1:8).*exp(1i*params(9:16));

    for n = 1:N
        sub_cost(n) = sqrt(mean((abs(S{n}*w)-T).^2));
    end
    
    costs = max(sub_cost);
    
    if(length(costs)>1)
      disp('something wrong');  
    end
    
end


function  costs = costMinTargetAbs(params,S)
    N = length(S);
    w = exp(1i*params(1:8));
    T = 1; % this is the goal
    %w = params(1:8).*exp(1i*params(9:16));

    for n = 1:N
        sub_cost(n) = mean(norm(abs(S{n}*w).^2 - T ).^2);
    end
    
    costs = max(sub_cost);
    
    if(length(costs)>1)
      disp('something wrong');  
    end
    
end


function  costs = costMinTargetAmp(params,S)
    N = length(S);
    w = params(1:8).*exp(1i*params(9:16));
    T = 1; % this is the goal
    %w = params(1:8).*exp(1i*params(9:16));
    for n = 1:N
        sub_cost(n) = sqrt(mean((abs(S{n}*w)-T).^2));
    end
    
    costs = max(sub_cost);
    
    if(length(costs)>1)
      disp('something wrong');  
    end
    
end

function [c,ceq] = limit_channel_RF_norm(params)
    w = params(1:8); % channel amplitudes
    c = [];
    ceq = w*w' - 8;
    % constraints
    %c = abs(w) - maxRF;
    
end
