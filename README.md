SON-EM 
==============

An algorithm for hybrid system identification of Switched affine AutoRegressive model with eXogenous inputs (SARX) models using Sum of Norms regularization and Expectation Maximization 

About this software
--------------
This software is to accompy the submission to “Identification of Switched ARX Models via Convex Optimization and Expectation Maximization” for publication Journal of Process Control by András Hartmann, João M. Lemos, Rafael S. Costa, João Xavier, and Susana Vinga

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

