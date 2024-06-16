# JID_ERP_Tactile_2024
Wenyu Wan, Leiden University and University of Amsterdam
## Preprocessing
To get clean EEG signals, the data was processed by using this script firstly:  
Did further procedure like refilter, epoch, baseline correction, reference, and etc.,  by using this function: **getANLcleandata()**  
## JID-ERPs
We got averaged ERP for each participant via **getANLerpavg()**;  
We separated tactile ERPs for each finger according to the previous and penultimate intervals into 5*5 two dimensional bins for each participant by **getANLbinerp()**;  
We got averaged JID-ERP across trials for each participant via **getANLbinerpavg()**;  
We gathered all participants' JID-ERPs by **getANLbinerpavg_all()**;  
We did one sample t-test for z(JID-ERP) vs. 0 and generate video 1,2,3 by **ANLonesampletest()**;  
## Cross-correlation analysis
We did cross correlation analysis and generate figure2C based on the grand averaged JID-ERPs by **getcorrplot_population()**;  
## Dimension reduction
We obtained the typical meta-JID and meta-ERP based on the sample JID-ERPs by using starNNMF toolbox and **main_nnmf()**;  
We obtained the typical meta-JID and averaged meta-ERP given individual variance by **ANLkmeans()**. Before that we ran starnnmf for each participant via **main_nnmf_individual()**.


