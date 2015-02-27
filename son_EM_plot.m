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
%uncomment this if you want to generate random time-series
%[y, Fi, Theta] = generateHMM(T,x0,u,r,1);

%We are only looking for one parameter
Y = (y - sum(Theta(2:4,:).*Fi(2:4,:)))';
fi = Fi(1,:)';

%Determining K
maxiter = 6;

res = inf(maxiter, 1);

for K = 1:maxiter
    theta = son_EM_son(Y, fi, T, K);
    th = Theta;
    th(1,:) = theta(:,:,3);
    res(K) = sum((y-sum(Fi.*th)).^2);
end;

%esitmates with lambda = 1, K = 4
lambda = 1;
K = 4;

theta = son_EM_son(Y, fi, T, K, lambda);


%plotting starts here

mylegends = {'step 1','step 2', 'step 3', 'Real parameter' };

figure
subplot(2,1,1)

plot(1:maxiter, res', 'o-', 'linewidth', 2)
xlabel(gca, 'K')
ylabel(gca, 'MSE')
set(gca,'ygrid', 'on')

subplot(2,1,2)

hold on
plot(theta(:,:,1), '--', 'linewidth',2);
plot(theta(:,:,2), 'r--', 'linewidth',2);
plot(theta(:,:,3), 'g--', 'linewidth',2);
plot(Theta(1,:), 'k-.', 'linewidth',2)

legend(mylegends,  'location', 'NorthWest')

l = ylabel(gca, '{\boldmath$\theta$}');

set(l,'Interpreter','latex','fontsize', 13);

set(gca,'ygrid', 'on')

xlabel(gca, 'time')

%print('son_EM_generated', '-depsc');
%save 'son_EM_generated';

