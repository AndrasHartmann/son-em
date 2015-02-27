function [Y, Fi, Theta] = generateHMM(tmax,x0,u,r,myseed, Am)
%function [Y, Fi, Theta] = generateHMM(tmax,x0,u,r,myseed, Am)
%generates time-series with Hidden Markov Model
%
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


% TODO: fix doc
if (nargin<6)
    Am = [  0.98    0.02    0       0;
    0.01    0.98    0.01    0;
    0       0.01    0.98    0.01;
    0       0       0.02    0.98];

end;

if(nargin==4)
    load('Theta');

else

    % This should generate random theta sequence, but to be reproducible rather we load a pre-saved theta

    %initialize random number generator
    %randn('seed', myseed)
    %rng('shuffle')

    %generating hmm sequence

    numstates = 4;
    statelevels = [-1.5 -1 -0.5 0.5];

    Emis = eye(numstates);

    th = hmmgenerate(tmax,Am,Emis,'Symbols',statelevels);

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
    fi = [Y(t-1); Y(t-2); u(t-1); u(t-2)];


    y = fi'*Theta(:,t) + r*randn;

    Fi(:,t) = fi;
    Y(t) = y;

end

