SON-EM 
==============

An algorithm for hybrid system identification of Switched affine AutoRegressive model with eXogenous inputs (SARX) models using Sum of Norms regularization and Expectation Maximization 


Cite this software
--------------

If you use this software please, cite the following paper:

Hartmann, A., Lemos, J. M., Costa, R. S., Xavier, J., & Vinga, S. (2015). Identification of Switched ARX Models via Convex Optimization and Expectation Maximization. Journal of Process Control, (28), 9–16.

Available at: http://dx.doi.org/10.1016/j.jprocont.2015.02.003

Installation
--------------

$tar -xzf son-em.tar.gz

Make the directory son-em accessible to MATLAB

###Prerequisites:
- Tested on MATLAB 7.14.0.739 (R2012a)
- Statistics Toolbox
- System Identification Toolbox
- CVX MATLAB package for convex optimization, available at http://cvxr.com/cvx/download/

Content
--------------

- runtests.m                    -> Run this to execute all tests (runs in about 1 minute on 2.4gHz cpu)
- LICENSE                       -> License file
- README.md                     -> This file
- generateHMM.m                 -> generates a hidden markov model
- son\_EM\_plot.m               -> plots an example time-series
- son\_EM\_sensitivity\_test.m  -> tests the sensitivity of the son\_em method to the lambda parameter
- son\_EM\_son.m                -> son\_em method
- Theta.mat                     -> example time-varying parameter

