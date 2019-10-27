function BandAnalysis(dataset,shift1,shift2,smt,~,PkLoc)

%isolate partial peak
    [a,~]=find(dataset(:,1)>shift1 & dataset(:,1)<shift2);
    peakdata=dataset(a,:);
    x=(peakdata(:,1));
    y=(peakdata(:,2));

%1st derivative
    %-generate spline using c smoothing spline function
    p=csaps(x,y,smt);
    %-identify zeros in first derivative
    drv=fnder(p,1);
    slop=ppval(drv,x);
    slop_ab=slop;
    slop_ab(slop_ab>=0)=0.2;
    slop_ab(slop_ab<0)=-0.2;
    slop_abd=zeros(length(x)-1,1);
    for i=1:length(x)-1
        slop_abd(i)=slop_ab(i+1)-slop_ab(i);
    end
    zero=find(slop_abd==0.4);
    if length(zero)<1
        xpk=0;
        ypk=0;
        apk=0;
    else
    %-identify the zero point which is cloest to the peak
        peak=[];
        for i=1:length(zero)
            xloc=zero(i)+1;
            peak_i=ppval(p,x(xloc));
            peak=cat(2,peak,peak_i);
        end
        [~,loc]=max(peak);
    %-intropolate and calculate peak value
        peakloc=zero(loc);
        fctn=@(f) ppval(drv,f);
        range=[x(peakloc),x(peakloc+1)];
        xpk=fzero(fctn,range);
        ypk=ppval(p,xpk);
    %-find area under peak
        apk=trapz(y);
    end

%interpolation from 'dataset'
    ypkI=interp1(dataset(:,1),dataset(:,2),PkLoc);

%center of gravity
    yCOGsum=0;
    xCOGsum=0;
    xyCOGsum=0;
    for i=1:length(a)
        yCOG_i=dataset(a(i),2);
        xCOG_i=dataset(a(i),1);
        xyCOG_i=yCOG_i*xCOG_i;
        yCOGsum=yCOGsum+yCOG_i;
        xCOGsum=xCOGsum+xCOG_i;
        xyCOGsum=xyCOGsum+xyCOG_i;
    end
    ypkC=xyCOGsum/xCOGsum;
    xpkC=xyCOGsum/yCOGsum;
    
%pass results to caller
    assignin('caller','ypkI',ypkI);
    assignin('caller','xpkD',xpk);
    assignin('caller','ypkD',ypk);
    assignin('caller','apkD',apk);
    assignin('caller','p',p);
    assignin('caller','xpkC',xpkC);
    assignin('caller','ypkC',ypkC);
    
end