function [Y, Fi, Theta] = generateHMM(tmax,x0,u,r,myseed, Am)
%function [Y, Fi, Theta] = generateHMM(tmax,x0,u,A,Theta,s0,r)
%generates time-series with Hidden Markov Model
% TODO: fix doc
% Y(t+1) = fi(t)'*th(t) + u(t) + e
% where 
% e ~ N(0,r^2)
% fi = [y(t); y(-1); u(t))
%example:
%tmax = 127;
%u = idinput(tmax,'prbs');
%x0 = 3;
%r = 0.5;
%[Y, Fi, Theta] = generateHMM(tmax,x0,u,r);
%plot(Y);
if (nargin<6)
    Am = [  0.98    0.02    0       0;
    0.01    0.98    0.01    0;
    0       0.01    0.98    0.01;
    0       0       0.02    0.98];

    %Am = [  0.98    0.02    0       0;
    %0.01    0.98    0.01    0;
    %0       0.01    0.94    0.05;
    %0       0       0.02    0.98];
end;

if(nargin==4)
    load('Theta');

else

    % This should generate random theta sequence, but... it can not be initialized, so rather we load a pre-saved theta

    %initialize random number generator
    %randn('seed', myseed)
    %rng('shuffle')

    %generating hmm sequence

    numstates = 4;
    statelevels = [-1.5 -1 -0.5 0.5];

    Emis = eye(numstates);

    %theta = kron(hmmgenerate(300,Am,Emis,'Symbols',statelevels), ones(1,10));
    th = hmmgenerate(tmax,Am,Emis,'Symbols',statelevels);

    %figure;
    %plot(th);
end;


Fi = zeros(4,tmax);
Theta = zeros(4,tmax);
Theta(1,:) = th;
Theta(2,:) = -0.7;
Theta(3,:) = 1;
Theta(4,:) = -0.5;

Y = ones(1,tmax)*x0;

for t=3:tmax

    %generating the time-series
    fi = [Y(t-1); Y(t-2); u(t-1); u(t-2)];% + [0.1*rand; 0.1*rand];


    y = fi'*Theta(:,t) + r*randn;

    Fi(:,t) = fi;
    %Theta(:,t) = theta;
    Y(t) = y;

end

