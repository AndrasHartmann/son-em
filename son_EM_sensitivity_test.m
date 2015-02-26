%Script that tests the sensitivity of the son_em method to the lambda parameter
%close all;
set(0,'DefaultAxesFontSize', 13)
set(0,'DefaultAxesFontWeight', 'bold')
set(0,'DefaultTextFontSize', 13)
set(0,'DefaultTextFontWeight', 'bold')
%generating the dataset
T = 127;
u = idinput(T,'prbs');
x0 = 3;
r = 0.5^2;
[y, Fi, Theta] = generateHMM(T,x0,u,r);

%We are only looking for one parameter
Y = (y - sum(Theta(2:4,:).*Fi(2:4,:)))';
fi = Fi(1,:)';

%parameters
p = 1;

maxiter = 21;
maxpar = 5;
minpar = 0.5;

lambda = linspace(minpar,maxpar,maxiter);
c= linspace(0.8,0.3,maxiter);
res = inf(maxiter,1);
K = 4;
options = statset('MaxFunEvals',10);

figure
subplot(3,1,1)
hold on
subplot(3,1,2)
hold on
subplot(3,1,3)
hold on

for i = 1:maxiter
    theta = son_EM_son(Y, fi, T, 4, lambda(i));
    for j = 1:3
        subplot(3,1,j)
        plot(theta(:,:,j), 'linewidth',2, 'Color', [c(i),c(i),c(i)]);
    end
    %err (i) = (fi.*theta(:,:,3)-Y)'*(fi.*theta(:,:,3)-Y);
end

subplot(3,1,1)
plot(Theta(1,:), 'g--', 'linewidth',2)
%legend(mylegends,  'location', 'southeast')

%title('SON regularization')
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

%print('son_EM_son_sensitivity', '-depsc');
%save 'son_EM_son_sensitivity'

