clear;clc;close all
base=datenum('2017-08-24_12_00_00','yyyy-mm-dd_HH_MM_SS');
tstep=6;   %%% time step that each wrfout file contains
for t=1:10
    t
    tt=func_datetime(base+(t-1)*6/24)
    wrfout=['TXGLO.atm.hi.2017-',num2str(tt(2),'%02d'),'-',num2str(tt(3),'%02d'),'_',num2str(tt(4),'%02d'),'_00_00.nc'];
    [slpt,xlongt,xlatt,minslpt,lonct,latct]=wrf_mslp_cal(wrfout);
    nn=size(slpt,3);
    
    slp(:,:,((t-1)*tstep+1):((t-1)*tstep+nn))=slpt;
    xlong=xlongt;xlat=xlatt;
    minslp(((t-1)*tstep+1):((t-1)*tstep+nn),1)=minslpt;
    lonc(((t-1)*tstep+1):((t-1)*tstep+nn),1)=lonct;
    latc(((t-1)*tstep+1):((t-1)*tstep+nn),1)=latct; 
    clear slpt xlongt xlatt minslpt lonct latct
    
    for t1=1:nn
        llonc=find(xlong(:,1)==lonc((t-1)*tstep+t1,1));
        llatc=find(xlat(1,:)==latc((t-1)*tstep+t1,1));
        rad=round(300/9);   %%% 300km
        sstr=round(50/9);   %%% 50km
        radx=min(llonc-1,285-llonc);
        rady=min(llatc-1,270-llatc);
        rad=min(rad,min(radx,rady));
        u10=ncread(wrfout,'U10',[max(llonc-rad,1),max(llatc-rad,1),t1],[2*rad+1,2*rad+1,1]);
        v10=ncread(wrfout,'V10',[max(llonc-rad,1),max(llatc-rad,1),t1],[2*rad+1,2*rad+1,1]);
        sst=ncread(wrfout,'SST',[max(llonc-sstr,1),max(llatc-sstr,1),t1],[2*sstr+1,2*sstr+1,1]);
        land=ncread(wrfout,'XLAND',[max(llonc-sstr,1),max(llatc-sstr,1),t1],[2*sstr+1,2*sstr+1,1]);
        sst(land==1)=nan;
        sstave((t-1)*tstep+t1,1)=nanmean(nanmean(sst,1),2);
        wspd=sqrt(u10.^2+v10.^2);
        mwspd((t-1)*tstep+t1,1)=max(max(wspd));
        clear u10 v10 wspd
    end
end

for i=1:size(minslp,1)
    tt=func_datetime(base+(i-1)*3/24);
    date(i,:)=['2017-',num2str(tt(2),'%02d'),'-',num2str(tt(3),'%02d'),'_',num2str(tt(4),'%02d')];
end
save('wrf_Harvey_SST3hrly.mat','lonc','latc','minslp','mwspd','date','sstave')



OBS=importdata('/scratch/user/fudan1991/GoM/Harvey/Harvey_NHC.txt');
OBS_info=OBS.data;
OBS_T=OBS.textdata;
d=(strcat(OBS_T(:,1),'-',OBS_T(:,2)));
for i=1:length(d)
  date1=d{i};
  dateo(i,:)=date1(1,1:13);
end   
timebase=datenum(dateo,'yyyy-mm-dd-hh');
timebasem=datenum(date,'yyyy-mm-dd_hh');
vend=find(mwspd<=17.5,1);

figure('position',[100 100 1200 800])
subplot(2,1,1)
plot(timebase,OBS_info(:,3)','-k','linewidth',2.0)
axis([timebase(1)-0.5 timebase(end)+0.5 920 1020])
index=find((dateo(:,12)=='0'&dateo(:,13)=='3')|(dateo(:,12)=='1'&dateo(:,13)=='5'));
xticks(timebase(index))
grid on
datelabel=dateo(:,9:13);
datelabel(:,6)='z';
set(gca,'xticklabel',datelabel(index,:),'tickdir','out','gridlinestyle','--')
title('Minimum Sea level Pressure (hPa)','fontsize',15)
hold on
plot(timebasem,minslp,'-b','linewidth',2.0)
%plot(timebasem(1:vend),minslp(1:vend),'-b','linewidth',2.0)

subplot(2,1,2)
plot(timebase,OBS_info(:,4)*1.852/3.6,'-k','linewidth',2.0)
axis([timebase(1)-0.5 timebase(end)+0.5 10 70])
xticks(timebase(1:3:end))
grid on
set(gca,'xticklabel',datelabel(1:3:end,:),'tickdir','out','gridlinestyle','--')
title('Maximum Surface Wind Speed (m/s)','fontsize',15)
hold on
plot(timebasem,mwspd,'-b','linewidth',2.0)
%plot(timebasem(1:vend),mwspd(1:vend),'-b','linewidth',2.0)



%addpath('/home/fudan1991/Matlab/m_map')
addpath(genpath('~/PACKAGE/Matlab'));
figure('Position',[0 0 600 600]);
gray=[.7 .7 .7];
m_proj('Mercator','lon',[-102 -82],'lat',[15 35]);
m_plot(1,1,'.k','markersize',20)
hold on
m_coast('patch',gray);
m_grid('tickdir','out','fontsize',15);
interval=3;
vend=find(mwspd<=17.5,1);
for i=2:length(OBS_T)
    m_plot(OBS_info(i-1:i,2),OBS_info(i-1:i,1),'-k','linewidth',2)
end

%for i=1:interval:vend-1
    m_plot(lonc,latc,'-b','linewidth',2)

    %m_plot(lonc(i:interval:i+interval,1),latc(i:interval:i+interval,1),'-b','linewidth',2)
    %if date(i,12:13)=='00' | date(i,12:13)=='12' % | date(i,12:13)=='12' | date(i,12:13)=='18'
    %    m_plot(lonc(i,1),latc(i,1),'.b','markersize',24)
    %end
%end
