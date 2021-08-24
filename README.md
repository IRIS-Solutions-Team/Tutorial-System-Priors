# Basic system prior analysis

This tutorial illustrates the definition and use of system priors in
estimating a simple gap model.


# Software requirements

* Matlab R2019b or newer

* Iris Toolbox Releasee 20210802 or newer


## Model source files

The model source files are located in the `model-source/` subfolder. 

The subfolder contains two model files:

* [`model-source/simple.model`](`model-source/simple.model) with a simple
  closed-economy gap model;

* [`model-source/hp.model`](model-source/hp.model) with a state space model
  for the Hodrick-Prescott filter (used for frequency domain
  illustrations).


## Matlab scripts

Read and run the Matlab scripts in the following order:

* [`run01_createModel`](run01_createModel.m)
* [`run02_simulateDisinflation`](run02_simulateDisinflation.m)
* [`run03_readDataFromFred.m`](run03_readDataFromFred.m)
* [`run04_experimentWithHP](run04_experimentWithHP.m)
* [`run05_filterData`](run05_filterData.m)
* [`run06_estimateParameters](run06_estimateParameters.m);

