function CalibrationForPlots

%load data
    [filename,path]=uigetfile('','Select Calibration File','*.txt');
    cd(path);
    try
        raw=dlmread({path filename});
    catch
        fID=fopen(filename);
        txtdata=textscan(fID,'%f%f','HeaderLines',1,'CollectOutput',1);
        fclose(fID);
        raw=txtdata{1};
    end

%trim data
    trim1=find(raw(:,1)<500, 1 );
    raw_tm1=raw;
    raw_tm1(trim1:end,:)=[];
    trim2=find(raw_tm1(:,1)>550, 1, 'last' );
    raw_tm2=raw_tm1;
    raw_tm2(1:trim2,:)=[];
    
%find Raman shift using FWHM
    input1=raw_tm2(:,1);
    input2=raw_tm2(:,2);
    BandFWHM(input1,input2);
    
%pass result to caller
    assignin('caller','wavenumber_cal',theta);
    
end

