function [th Theta IDX] = son_EM_son(y, Fi, T, K, lambda1, p)
%SON-EM algorithm for hybrid system identification of Switched affine AutoRegressive model with eXogenous inputs (SARX) models
%
%    If you use this software please, cite the following paper:
%    Hartmann, A., Lemos, J. M., Costa, R. S., Xavier, J., & Vinga, S. (2015).
%    Identification of Switched ARX Models via Convex Optimization and 
%    Expectation Maximization. Journal of Process Control, (28), 9–16. 
%    doi:10.1016/j.jprocont.2015.02.003
%
%function [th Theta] = son_EM_son(y, Fi, T, K, lambda1, p)
%SON-EM algorithm
% y: measurements
% Fi: regression vector
% T: number of measurements
% K: number of discrete states
% lambda1: regularization constant, default = 1
% p: norm of regularization, default = 1
%
% return: 
% th: the parameter vector, the rows correspond to the identified parameters after each step of the algorithm
% Theta: nXK matrix of parameter vectors
%
%
%    SON-EM - An algorithm for hybrid system identification of SARX models 
%    Copyright (C) 2013-2015 Andras Hartmann <andras.hartmann@gmail.com>
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

%default parameters
if nargin < 6
    p = 1;
    if nargin < 5
        lambda1 = 1;
    end;
end;

%initialize parameters
th = nan([size(Fi) 3]);

%SON regularization
S = zeros(T,T);
Q = sparse(S);
i=1;
for t=1:T-1
        Q(t,t)=1;
        Q(t,t+1)=-1;
end

%First step - solving a regularized convex problem
cvx_begin quiet
variable theta(size(Fi));
minimize (sum(sum((sum(Fi.*theta,2)-y).*(sum(Fi.*theta,2)-y)))+lambda1*sum(norms((Q*theta)',p)));
cvx_end

th(:,:,1) = theta;

if K <= 1
    th(:,:,2) = repmat(mean(th(:,:,1)), T, 1);
    th(:,:,3) = repmat(mean(th(:,:,1)), T, 1);
    return;
    %FIXME: could be done better?
end

%Second step - applying EM
options_kmeans = statset('MaxFunEvals',10, 'MaxIter', 10);
options_EM = statset('MaxFunEvals',100, 'MaxIter', 100, 'TolFun', 1e-9);

nlogl=inf;
IDX = 0;
miu = 0;

%tic
for iter = 1:10
    try
        %Some steps of kmeans
        %Disable some warnings, we do not care if it does not converge
        warning('off', 'stats:kmeans:EmptyCluster');
        warning('off', 'stats:kmeans:FailedToConverge');
        [idx_init,~,~,~] = kmeans(theta,K, 'emptyaction', 'singleton', 'replicates', 100, 'onlinephase', 'off', 'options', options_kmeans);
        warning('on', 'stats:kmeans:EmptyCluster');
        warning('on', 'stats:kmeans:FailedToConverge');

        warning('off', 'stats:gmdistribution:FailedToConverge');
        obj = gmdistribution.fit(theta,K,'Start', idx_init, 'Regularize', 10^-8, 'options', options_EM);
        warning('on', 'stats:gmdistribution:FailedToConverge');
        [IDX_,nlogl_] = cluster(obj,theta);
        if nlogl_<nlogl
            nlogl = nlogl_;
            IDX = IDX_;
            miu = obj.mu;
        end
    catch err
        str = ['error in replica ' int2str(iter) ': ' err.message];
        disp(str);
        iter = iter-1;
    end
end
%toc


th(:,:,2) = miu(IDX,:);

indicator = zeros(T, size(miu,2));
for t = 1:T
    indicator(t,IDX(t)) = 1;
end
indicator = sparse(indicator);

%Third step - solving another optimization problem
cvx_begin quiet
variable Theta(size(miu));
minimize (sum(sum((sum(Fi.*(indicator*Theta),2)-y).*(sum(Fi.*(indicator*Theta),2)-y))));
cvx_end

th(:,:,3) = indicator*Theta;
