# CRESM - Ensemble

### The RCESM (Regional Community Earth System Model), or so-called CRESM, is a fully coupled regional model developed jointly by NCAR and Texas A&M University. The model is a revision from the Coupled Regional Climate Model (CRCM) that was developed from Texas A&M University. The current version of the RCESM can be seen in https://ihesp.github.io/rcesm1/introduction.html. 



The goal of this repository is showing a way to operate an automatic RCESM ensemble runs, based on RCESM v1.0.  
> Initial and boundary condition for atm and ocn components.  
> The data for the atmosphere component is using GEFS.  
> The data for the ocean component is using Marine Copernicus Analysis Product.  


This repository is fully tested. 
- The validation report are reported to Texas General Land Office (TGLO)
- The use in research was presented in the AMS 99th Annual Meeting by Dr. Chuan-Yuan Hsu



Requirements:  
1. PYROMS   
2. MARINE COPERNICUS MOTU-CLIENT PYTHON API  
3. WRF and WPS  


Before Run:

  OCN:
  
    1. Setup your grid-mapping files, see pyroms for detail.
    2. Setup your Marine Copernicus moto-client python api, see Marine Copernicus Products for detail.
    
  ATM:
  
    1. Setup WRF and WPS in atm/data.
    
The setup of this repository is based on the Texas A&M University Super-Computer ADA.

If you have any problem, please contact with me.
