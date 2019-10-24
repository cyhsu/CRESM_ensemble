%calculates sea level pressure on the basis of data available in 
% typical wrf output file. Uses methodology described in INTERPB section of
% MM5 user's guide
%function [pslv,xlong,xlat,minslp,lonc,latc]=wrf_mslp_cal(wrfname)
% Author: Ivan Kovalets, 2011
% Modified by Dan Fu, 2017


function [pslv,xlong,xlat,minslp,lonc,latc]=wrf_mslp_cal(wrfname, ncid)

if nargin<2
    ncid=netcdf.open(wrfname,'NC_NOWRITE');
end

%varid=netcdf.inqVarID(ncid,'XLONG');
%xlong=netcdf.getVar(ncid,varid);

%varid=netcdf.inqVarID(ncid,'XLAT');
%xlat=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'ZNW');
znw=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'ZNU');
znu=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'P');
p=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'PB');
pb=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'PH');
ph=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'PHB');
phb=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'T');
tpot=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'HGT');
hgt=netcdf.getVar(ncid,varid);

varid=netcdf.inqVarID(ncid,'PSFC');
psfc=netcdf.getVar(ncid,varid);

xlong=ncread(wrfname,'XLONG',[1,1,1],[size(psfc,1),size(psfc,2),1]);
xlat=ncread(wrfname,'XLAT',[1,1,1],[size(psfc,1),size(psfc,2),1]);

tpot=tpot+300;

[pslv]=calcpslv(znw, znu, p, pb, ph, phb, tpot, hgt, psfc);

if nargin<2
    netcdf.close(ncid);
end

for tt=1:size(pslv,3);
    [minslp(tt,1),idx]=min(reshape(pslv(:,:,tt),[size(pslv,1)*size(pslv,2),1]));
    [row,col]=find(pslv(:,:,tt)==minslp(tt,1));
    lonc(tt,1)=xlong(row(1),1);
    latc(tt,1)=xlat(1,col(1));
    clear row col
end
    
    



end

% returns 2 arrays L1, L2 which contain vertical indices such, that the 
% corresponding sigma values surround level of 100 mb pressure drop
% relative to surface
function [pslv]=calcpslv(znw, znu, p, pb, ph, phb, tpot, hgt, psfc)

Ra=287.05;
Cpa=1005;

pt=5000;
for t=1:size(p,4)
    disp(['Time step of ',num2str(t),' is processing'])
for i=1:size(p,1)
    for j=1:size(p,2)
        pbot=pb(i,j,1,t)+p(i,j,1,t); %only for diagnostics; should be the same as psfc
        ps=psfc(i,j,t);
        pbhydr=pb(i,j,1,t);

        for k=1:size(p,3)-1
            if(ps-p(i,j,k,t)-pb(i,j,k,t)<10000 && ps - p(i,j,k+1,t)-pb(i,j,k+1,t)>=10000)
                k0=k;
                break;
            end
        end
        
        p0=znu(k0,t)*(pbhydr-pt)+pt+0.5*(p(i,j,k0,t)+p(i,j,k0+1,t));
        
        t0pot=tpot(i,j,k0,t);
        t0=tpot(i,j,k0,t)/power(100000/p0,Ra/Cpa);
        
        
        Ts=t0*power(ps/p0,Ra*0.0065/9.81);
        
        Tm=0.5*(Ts+t0);
        
        Z=hgt(i,j,t)-(Ra/9.81)*log(p0/ps)*Tm;
        
        Tslv=t0+0.0065*Z;
        
        pslv(i,j,t)=ps*exp(9.81*hgt(i,j,t)/Ra/(0.5*(Tslv+Ts)))/100;   %unit in hPa
      
        
        
    end
end
end
return;
            
end




