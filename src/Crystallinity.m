function Crystallinity(dataset)

%isolate partial peak
    [a,~]=find(dataset(:,1)>850 & dataset(:,1)<1050);
    peakdata=dataset(a,:);
    x=(peakdata(:,1)).';
    y=smooth((peakdata(:,2)).',2,'moving');

%find half value and interpret relative indices
    y_hmax=max(y)/2;
    hf_idx1=find(peakdata(:,2)>y_hmax,1) +[-1 0];
    hf_idx2=find(peakdata(:,2)>y_hmax,1,'last') +[0 1];
    x_hf1=interp1(y(hf_idx1),x(hf_idx1),y_hmax);
    x_hf2=interp1(y(hf_idx2),x(hf_idx2),y_hmax);
    
%find theta value
    peakwidth=x_hf1-x_hf2;

% Send results to 'caller'.
    assignin('caller','halfheight',y_hmax);
    assignin('caller','xwidth1',x_hf1);
    assignin('caller','xwidth2',x_hf2);
    assignin('caller','peakwidth',peakwidth);
end