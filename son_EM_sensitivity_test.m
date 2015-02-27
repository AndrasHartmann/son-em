%Script that tests the sensitivity of the son_em method to the lambda parameter
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

clear;

%generating the dataset
T = 127;
u = idinput(T,'prbs');
x0 = 3;
r = 0.5^2;
[y, Fi, Theta] = generateHMM(T,x0,u,r);

%We are only looking for one parameter
Y = (y - sum(Theta(2:4,:).*Fi(2:4,:)))';
fi = Fi(1,:)';

%parameters for the loop
maxiter = 21;
maxpar = 5;
minpar = 0.5;
lambda = linspace(minpar,maxpar,maxiter);

%Colors
c = linspace(0.8,0.3,maxiter);

%Number of modes
K = 4;

figure
subplot(3,1,1)
hold on
subplot(3,1,2)
hold on
subplot(3,1,3)
hold on

for i = 1:maxiter
    theta = son_EM_son(Y, fi, T, K, lambda(i));
    for j = 1:3
        subplot(3,1,j)
        plot(theta(:,:,j), 'linewidth',2, 'Color', [c(i),c(i),c(i)]);
    end
end

%plot real parameters
subplot(3,1,1)
plot(Theta(1,:), 'g--', 'linewidth',2)

%Finish plots, labels, etc
set(gca,'ygrid', 'on')

l = ylabel(gca, '{\boldmath$\theta$}');
set(l,'Interpreter','latex','fontsize', 13);

set(gca,'ylim', [-2 1]);


subplot(3,1,2)

plot(Theta(1,:), 'g--', 'linewidth',2)


set(gca,'ygrid', 'on')

l = ylabel(gca, '{\boldmath$\theta$}');
set(l,'Interpreter','latex','fontsize', 13);

set(gca,'ylim', [-2 1]);


subplot(3,1,3)

plot(Theta(1,:), 'g--', 'linewidth',2)


set(gca,'ygrid', 'on')

l = ylabel(gca, '{\boldmath$\theta$}');
set(l,'Interpreter','latex','fontsize', 13);

xlabel(gca, 'time')
set(gca,'ylim', [-2 1]);

%Uncomment this if you want to print / save
%print('son_EM_son_sensitivity', '-depsc');
%save 'son_EM_son_sensitivity'

