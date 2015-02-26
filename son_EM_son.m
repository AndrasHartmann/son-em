function [th Theta] = son_EM_son(y, Fi, T, K, lambda1, p)
%SON-EM algorithm for hybrid system identification of Switched affine AutoRegressive model with eXogenous inputs (SARX) models
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
%
%Copyright (C) 2013-2015 Andras Hartmann <andras.hartmann@gmail.com>
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
        warning('off', 'stats:kmeans:EmptyCluster');
        [idx_init,~,~,~] = kmeans(theta,K, 'emptyaction', 'singleton', 'replicates', 100, 'onlinephase', 'off', 'options', options_kmeans);
        warning('on', 'stats:kmeans:EmptyCluster');
        obj = gmdistribution.fit(theta,K,'Start', idx_init, 'Regularize', 10^-8, 'options', options_EM);
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
