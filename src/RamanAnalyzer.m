% Copyright (c) 2019 Hokkaido University

% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


%% Initialize
launcher=Launcher;
spectrum_analysis=0;
window_close=0;
launcher_status=1;
load_bio_para='On';
waitfor(launcher);


%% Main Body
while window_close==0
    
    if spectrum_analysis==1  
        try         
    %SET DEFAULT PARAMETERS
            if isequal(load_bio_para,'On')
        %calibration             
            %-calibrate before each run? '1'=YES, '0'=NO
                cal=1; %if cal=0, run seperate manual calibration file and entre value below.
                auto_cal=1;
                wavenumber_ref = 520.5;
                wavenumber_input = 524.7452;

        %trimming
                trim=1; %'1'=apply trim, '0'=NOT apply trim
            %-start and end point
                start_tm=800;
                end_tm=1800;

        %smoothing
            %-Order of function
                order_smt=2;
            %-Window size
                size_smt=9;

        %background removal
            %-Method, '1'=Modified Polynomial, '0'=Polynomial
                bg_rmv=1;
            %-Order of polynomial
                order_bk=4;

        %normalization
                norm_type=2; %'1'=vectoring,'2'=SNV,'3'=Min-Max,'4'=use peak as reference

        %peaks Parameters [shift_start, shift_end, shift_peak, smooth factor, HWHM, band isolation start, band isolation end]
            %-Phosphate v1 (PO4 v1)
                pk1_1=930;pk1_2=980;pk1_3=960;pk1_4=0.99;pk1_5=30;pk1_6=880;pk1_7=1005;
                pk1=[pk1_1 pk1_2 pk1_3 pk1_4 pk1_5 pk1_6 pk1_7];
                pk1a='Phosphate v1';
            %-Amide I
                pk2_1=1550;pk2_2=1750;pk2_3=1670;pk2_4=0.8;pk2_5=50;pk2_6=1500;pk2_7=1800;
                pk2=[pk2_1 pk2_2 pk2_3 pk2_4 pk2_5 pk2_6 pk2_7];
                pk2a='Amide I';
            %-Methylen (CH2)
                pk3_1=1430;pk3_2=1540;pk3_3=1454;pk3_4=0.8;pk3_5=30;pk3_6=1100;pk3_7=1570;
                pk3=[pk3_1 pk3_2 pk3_3 pk3_4 pk3_5 pk3_6 pk3_7];
                pk3a='Methylene(CH2)';
            %-Amide III
                pk4_1=1220;pk4_2=1355;pk4_3=1270;pk4_4=0.8;pk4_5=60;pk4_6=0;pk4_7=0;
                pk4=[pk4_1 pk4_2 pk4_3 pk4_4 pk4_5 pk4_6 pk4_7];
                pk4a='Amide III';
            %-B-type Carbonated Apatite (CO3)
                pk5_1=1060;pk5_2=1090;pk5_3=1075;pk5_4=0.8;pk5_5=15;pk5_6=970;pk5_7=1170;
                pk5=[pk5_1 pk5_2 pk5_3 pk5_4 pk5_5 pk5_6 pk5_7];
                pk5a='Carb. Apt. (CO3)';
            %-Proline/Hydroxyproline Complex
                pk6_1=835;pk6_2=900;pk6_3=855;pk6_4=0.8;pk6_5=30;pk6_6=815;pk6_7=915;
                pk6=[pk6_1 pk6_2 pk6_3 pk6_4 pk6_5 pk6_6 pk6_7];
                pk6a='Pro/Hyp';
            %-Proline
                pk7_1=840;pk7_2=870;pk7_3=853;pk7_4=0.8;pk7_5=10;pk7_6=0;pk7_7=0;
                pk7=[pk7_1 pk7_2 pk7_3 pk7_4 pk7_5 pk7_6 pk7_7];
                pk7a='Proline';
            %-Hydroxyproline
                pk8_1=870;pk8_2=900;pk8_3=877;pk8_4=0.8;pk8_5=10;pk8_6=0;pk8_7=0;
                pk8=[pk8_1 pk8_2 pk8_3 pk8_4 pk8_5 pk8_6 pk8_7];
                pk8a='Hydroxyproline';
            %-Xtra Peak 1
                pk9_1=0;pk9_2=0;pk9_3=0;pk9_4=0;pk9_5=0;pk9_6=0;pk9_7=0;
                pk9=[pk9_1 pk9_2 pk9_3 pk9_4 pk9_5 pk9_6 pk9_7];
                pk9a='';
            %-Xtra Peak 1
                pk10_1=0;pk10_2=0;pk10_3=0;pk10_4=0;pk10_5=0;pk10_6=0;pk10_7=0;
                pk10=[pk10_1 pk10_2 pk10_3 pk10_4 pk10_5 pk10_6 pk10_7];
                pk10a='';
                pk_para=[pk1;pk2;pk3;pk4;pk5;pk6;pk7;pk8;pk9;pk10];
                pk_names={pk1a pk2a pk3a pk4a pk5a pk6a pk7a pk8a pk9a pk10a};

        %set checkboxes default
                pk1c=1;
                pk2c=1;
                pk3c=1;
                pk4c=1;
                pk5c=1;
                pk6c=1;
                pk7c=1;
                pk8c=1;
                pk9c=0;
                pk10c=0;

        %markers dislplayed on plot, '1'=Display, '0'=NOT Display
            %-Center of Gravity
                d1=1;
            %-Peak local maxima
                d2=1;
            %-Interpolated local maxima at assigned peak shift values
                d3=1;
            %-Interpoated peak values for sub-peaks in Amide I and III
                d4=0;

        %sample type override
                override=0; %'1'=override ON, '0'=override OFF
                type=0; %'1'=mineralized, '0'=NON-mineralized

        %curve Fitting
            %-Perform curve fitting?
                run_curve_fit=0; %'1'=YES; '0'=NO
            %-curve fitting parameters
                %--1.apply linear back ground removal? '0'=NO; '1'=YES
                remove_background=1;
                %--2.do you want to fix sub-curves' peak loacation? '1'=YES; '0'=NO
                fix_location=0;
                %-if peak locations are fixed (fix_location=1), do you want to enter peak locations using keyboard?
                type_locs=0; %'0'=automatically get locs from mouse clicks; '1'=manually enter locs via keyboard
                %--3.which fitting function do you want to use? 
                fun_type=2; %'0'=Gaussian; '1'=Lorentzian; '2'=Gauss-Lorenz Mix (G-L)
                frac=0.7; %if using G-L, enter GAUSSIAN fracton here
                %--4.which fitting algorithm do you want to use? '0'=Trust-Region-Reflective
                %(matlab default); '1'=Levenberg-Marquardt
                algo=0;

        %perform measurements on isolated peaks
                pkana=1; % '1'=YES; '0'=NO
            else
                DefaultsGeneral;
            end

        %confirm directory for file saving   
            i=msgbox('Please Select Your Working Directory. Resutls Will Be Saved in This Folder','Getting Directory','help');
            waitfor(i);
            newdir=uigetdir('','Set Working Directory');        
            l_dir=strlength(newdir);
            current_foldr=cd(newdir);
            repeat=1;
            newpara=1;

            
    %RELOAD DEFAULT PARAMETERS FOR REPEATS
            while repeat==1   
                abort=0;
                if newpara==1
                    para_input=1;
                    while para_input==1
                        if isequal(load_bio_para,'On')
                            DefaultsBiological;
                            UIF=ParameterInputBiological;
                        else
                            DefaultsGeneral;
                            UIF=ParameterInputGeneral;
                        end
                        waitfor(UIF);
                        if rem(size_smt,2)~=1
                            errmsg=msgbox({'Savitzky-Golay Smoothing Window Size Has To Be An Odd Positive Number.';[];'Please Try Again.'},'Smoothing Setting','warn');
                            waitfor(errmsg);  
                        else
                            para_input=0;
                        end
                    end
                    pk1=[pk1_1 pk1_2 pk1_3 pk1_4 pk1_5 pk1_6 pk1_7];
                    pk2=[pk2_1 pk2_2 pk2_3 pk2_4 pk2_5 pk2_6 pk2_7];
                    pk3=[pk3_1 pk3_2 pk3_3 pk3_4 pk3_5 pk3_6 pk3_7];
                    pk4=[pk4_1 pk4_2 pk4_3 pk4_4 pk4_5 pk4_6 pk4_7];
                    pk5=[pk5_1 pk5_2 pk5_3 pk5_4 pk5_5 pk5_6 pk5_7];
                    pk6=[pk6_1 pk6_2 pk6_3 pk6_4 pk6_5 pk6_6 pk6_7];
                    pk7=[pk7_1 pk7_2 pk7_3 pk7_4 pk7_5 pk7_6 pk7_7];
                    pk8=[pk8_1 pk8_2 pk8_3 pk8_4 pk8_5 pk8_6 pk8_7];
                    pk9=[pk9_1 pk9_2 pk9_3 pk9_4 pk9_5 pk9_6 pk9_7];
                    pk10=[pk10_1 pk10_2 pk10_3 pk10_4 pk10_5 pk10_6 pk10_7];
                    pk_para=[pk1;pk2;pk3;pk4;pk5;pk6;pk7;pk8;pk9;pk10];
                    pk_names={pk1a pk2a pk3a pk4a pk5a pk6a pk7a pk8a pk9a pk10a};
                    cd(newdir);
                end    
                if abort==1                
                    break
                end
                lastrun_curve_fit=run_curve_fit;
               
                
    %PRE-ANALYSIS               
        %calibration value
                break_out1=0;
                if cal==1
                    if auto_cal==1
                        run_cal=1;                    
                        i=msgbox('Please Select File for Calibration.','Get Calibration File','help');
                        waitfor(i);
                        while run_cal==1
                            cal_err=0;
                            try
                                Calibration;
                                cd(newdir);
                                run_cal=0;
                            catch
                            end
                        end
                        if cal_err==1
                            break_out1=1;
                            cal_err=0;
                            break
                        end
                        wavenumber_input=wavenumber_cal;
                    else
                        wavenumber_cal=wavenumber_input; 
                    end
                else
                    wavenumber_cal=wavenumber_ref;
                end
                if break_out1==1
                    break
                end
                
        %import files
                i=msgbox('Parameter-Input Complete. Please Select Folder for Analysis.','Get File-Containing Folder','help');
                waitfor(i);
                import_files=1;
                while import_files==1  
                    break_out2=0;
                    import_files=0;
                    dir_check=[];
                    path=uigetdir('','Select Folder For Analysis');
                    if path==0
                        break_out2=1;
                        break
                    end
                    l_path=strlength(path);                  
                    if l_path==l_dir
                        dir_check=strcmp(path,newdir);
                    elseif l_path>l_dir
                        pathi=path;
                        pathi(l_dir+1:end)=[];
                        dir_check=strcmp(pathi,newdir);
                        if dir_check~=0
                            if ~isequal(path(l_dir+1),'\') 
                                dir_check=0;
                            end
                        end 
                    end                 
                    if l_path<l_dir || dir_check==0
                        i=questdlg({'The Selected Folder is OUTSIDE of the Working Directory.';'Do You Want to Continue?'},'Confirm Directory','YES','CHANGE DIRECTORY TO CURRENT FOLDER','SELECT NEW DIRECTORY','SELECT NEW DIRECTORY');
                        switch i
                            case 'YES'
                                cd(path);
                            case 'CHANGE DIRECTORY TO CURRENT FOLDER'
                                newdir=path;
                                l_dir=strlength(newdir);
                                cd(newdir);
                                import_files=1;
                            case 'SELECT NEW DIRECTORY'
                                newdir=uigetdir('','Set Working Directory');
                                l_dir=strlength(newdir);
                                cd(newdir);     
                                import_files=1;
                        end
                    end                                     
                    [~,name]=fileparts(path);
                    files=fullfile(path,'*.txt');
                    d=dir(files);                   
                    if numel(d)==0
                        i=msgbox('The Selected Folder Contains NO Usable File.Please Try Again.','Get File-Containing Folder','warn');
                        waitfor(i);
                        import_files=1;
                    end                                         
                    y_raw=[];
                    for i=1:numel(d)
                        file_i=fullfile(path,d(i).name);
                        try
                            raw=dlmread(file_i);
                        catch
                            fID=fopen(file_i);
                            txtdata=textscan(fID,'%f%f','HeaderLines',1,'CollectOutput',1);
                            fclose(fID);
                            raw=txtdata{1};
%                         end
                            check_format=isnan(txtdata{1});
                            if isempty(txtdata{1})
                                errmsg=msgbox('.txt File Can Only Have Less Than Two Lines Of Header.','Check File Format','error');
                                waitfor(errmsg);
                                import_files=1;
                                break
                            elseif ~isempty(find(check_format,1))
                                errmsg=msgbox('More Than Two Columns Is Detected In The .txt File.','Check File Format','error');
                                waitfor(errmsg);
                                import_files=1;
                                break
                            end
                        end
                        y_rawi=raw(:,2);
                        y_raw=cat(2,y_raw,y_rawi);
                    end
                end
                if break_out2==1
                    break
                end
                           
        %cosmic ray removal
                x=raw(:,1);
                x_raw=x;
                colnmbr=[];
                CosmicRayRemoval(x,y_raw,colnmbr);
                while runcr==1
                    try
                        CosmicRayRemoval(x,y_raw,colnmbr);
                    catch
                        runcr=0;
                    end
                end

        %trim/shift correction/smoothing/background removal/normalization
            %-for normalization by reference peak
                if norm_type==4
                    figure('units','normalized','outerposition',[0 0 1 1]);
                    plot(x,mean(y_raw,2));
                    axis([start_tm end_tm 0 max(mean(y_raw,2)*1.2)]);
                    hold on;
                    i=msgbox('Please Select the Reference Peak for Normalization.','Select Reference Peak','help');
                    waitfor(i);
                    [locnrm,intnnrm]=ginput(1);
                    close;
                end
                waita=waitbar(0,'Analyzing... 0%','Name','Please Wait');
                size_y=size(y_raw); 
                x_norm=x;
                y_norm=[];
                y_smt=[];
                for i=1:size_y(2)
                    raw_i=[x_norm,y_raw(:,i)];
                    
        %trim data
                    if trim==1
                        check_trim=1;
                        while check_trim==1
                            raw_i_range=[min(raw_i(:,1)),max(raw_i(:,1))];
                            trim1=find(raw_i(:,1)<start_tm, 1 );
                            raw_tm1=raw_i;
                            raw_tm1(trim1:end,:)=[]; 
                            trim2=find(raw_tm1(:,1)>end_tm, 1, 'last' );
                            if isempty(trim1) || isempty(trim2)
                                errmsg=msgbox({['The Trim Range (' num2str(start_tm) ' to ' num2str(end_tm) ') Exceeded The Data Range (' num2str(raw_i_range(1)) ' to ' num2str(raw_i_range(2)) ').'];[];'Please try again.'},'Warning','warn');
                                waitfor(errmsg);
                                check_input=1;
                                while check_input==1
                                    prompt = {'START Wavenumber:','END Wavenumber:'};
                                    dlgtitle = 'Trim Range';
                                    dims = [1 50];
                                    answer = inputdlg(prompt,dlgtitle,dims);
                                    if numel(answer)==0
                                        errmsg=msgbox({'Invalid Entry';[];'Please try again.'},'Warning','warn');
                                        waitfor(errmsg);
                                    elseif str2double(answer{2})<str2double(answer{1})
                                        errmsg=msgbox({'End Wavenumber Is Smaller Than Start.';[];'Please try again.'},'Warning','warn');
                                        waitfor(errmsg);
                                    elseif str2double(answer{2})-str2double(answer{1})<size_smt+5
                                        errmsg=msgbox({'Range Too Small';[];'Please try again.'},'Warning','warn');
                                        waitfor(errmsg);
                                    else
                                        start_tm=str2double(answer{1});
                                        end_tm=str2double(answer{2});
                                        if isnan(start_tm) || isnan(end_tm)
                                            errmsg=msgbox({'Invalid Entry';[];'Please try again.'},'Warning','warn');
                                            waitfor(errmsg);
                                        else
                                            check_input=0;
                                        end
                                    end
                                end
                            else
                                check_trim=0;
                            end
                        end                       
                        raw_tm2=raw_tm1;
                        raw_tm2(1:trim2,:)=[];
                    else
                        raw_tm2=raw_i;
                    end
                    
        %apply shift calibration
                    raw_tm2(:,1)=raw_tm2(:,1)-(wavenumber_cal-wavenumber_ref);
                    
        %apply Savitzky-Golay smoothing
                    raw_smt=sgolayfilt(raw_tm2,order_smt,size_smt);
                    y_smt=cat(2,y_smt,raw_smt);
                    
        %background removal
            %-turn off warning
                    id='MATLAB:polyfit:RepeatedPointsOrRescale';
                    warning('off',id);
                    if bg_rmv==0
            %-polyfitting
                        p=polyfit(raw_smt(:,1),raw_smt(:,2),order_bk);
            %-Evaluate fit
                        x=raw_smt(:,1);
                        y=polyval(p,x);
                    else
            %-modified polyitting
                        raw_mod=raw_smt;
                        x=raw_mod(:,1);
                        for ii=1:200
                            y=raw_mod(:,2);
                            p=polyfit(raw_mod(:,1),raw_mod(:,2),order_bk);
                            y1=polyval(p,x);
                            y2=y-y1;
                            [locs,]=find(y2>=0);
                            y(locs)=y1(locs);
                            raw_mod=[x,y];
                        end
                    end
            %-remove baseline
                    y_bgr=raw_smt(:,2)-y;
                    
        %normalization
                    if norm_type==1
            %-vectoring
                        norm=sqrt(sum(y_bgr.^2));
                        yn=y_bgr/norm;
                    elseif norm_type==2
            %-standard normal variate (SNV)
                        avg=mean(y_bgr);
                        stdv=std(y_bgr);
                        yn=(y_bgr-avg)/stdv;
                    elseif norm_type==3
            %-Min/Max
                        yn=(y_bgr-min(y_bgr))/(max(y_bgr)-min(y_bgr));
                    elseif norm_type==4
                        ids=find(x>(locnrm-15) & x<(locnrm+15));
                        x_ids=x(ids);
                        ymax=max(y_bgr(ids));
                        yn=y_bgr/ymax;
                    else
                        yn=y_bgr;
                    end
                    y_norm=cat(2,y_norm,yn);
                    perct=0.9/size_y(2)*i;
                    waitbar(perct,waita,['Analyzing... ' num2str(perct*100) '%'],'Name','Please Wait');
                end
                
        %get data average
                smt_yavg=[];
                norm_yavg=[];
                for i=1:numel(y_smt(:,1))
                    yi=mean(y_smt(i,:));
                    smt_yavg=cat(1,smt_yavg,yi);
                end
                for i=1:numel(y_norm(:,1))
                    yi=mean(y_norm(i,:));
                    norm_yavg=cat(1,norm_yavg,yi);
                end
                norm_avg=[x norm_yavg-min(norm_yavg)];
                
        %get data stamdard deviation
                sd=[];
                for i=1:numel(y_norm(:,1))
                    sdi=std(y_norm(i,:));
                    sd=cat(1,sd,sdi);
                end
                stdev=[x sd];
                if trim==0
                    start_tm=fix(min(x));
                    end_tm=fix(max(x))+1;
                end
                
        %plot smoothed data
                F1=figure('units','normalized','outerposition',[0 0 1 1]);
                plot(raw_smt(:,1),raw_smt(:,2));
                axis([start_tm end_tm -inf max(raw_smt(:,2))*1.2]);
                xlabel('Raman shift (cm^{-1})')
                ylabel('Intensity (cps)')
                hold on;
                title(['Sample ',name,' -Background Removal']);
            %-plot baseline
                plot(x,y,'--','Color','r');
            %-plot baseline removed data
                plot(x,y_bgr,'Color','k');
            %-add legend
                legend('smoothed raw','fitted background','background removed');
                figure(waita);

        %determine sample type
                if override==1
                 sample_type=type;
                end
                [intnx1,~]=find(norm_avg(:,1)>900 & norm_avg(:,1)<1000);
                [intnx2,~]=find(norm_avg(:,1)>1440 & norm_avg(:,1)<1470);
                if max(norm_avg(intnx1,2))>max(norm_avg(intnx2,2))
                   sample_type=1;
                else
                   sample_type=0;
                end
                raman=[x,norm_avg(:,2)];

        %find spectral resolution
                [datasize,col]=size(raman);
                shiftrange=max(raman(:,1))-min(raman(:,1));
                resolution=shiftrange/datasize;
                

    %ANALYSIS
    
        %check input wavenumber ranges
                pkcs=[pk1c pk2c pk3c pk4c pk5c pk6c pk7c pk8c pk9c pk10c];
                pkc_id=find(pkcs==1);
                pkc_changes=zeros(1,10);
                pk_changes=zeros(1,10);   
                for i=1:numel(pkc_id)
                    if pk_para(pkc_id(i),1)<=min(raw_tm2(:,1)) && pk_para(pkc_id(i),2)<=min(raw_tm2(:,1))+10
                        eval(sprintf('pk%ic=0',pkc_id(i)));
                        pkc_changes(pkc_id(i))=1;
                    end
                    if pk_para(pkc_id(i),1)>=max(raw_tm2(:,1)-10) && pk_para(pkc_id(i),2)>=max(raw_tm2(:,1))
                        eval(sprintf('pk%ic=0',pkc_id(i)));
                        pkc_changes(pkc_id(i))=1;
                    end
                    if pk_para(pkc_id(i),1)<min(raw_tm2(:,1))&& pk_para(pkc_id(i),2)>min(raw_tm2(:,1))+10
                        eval(sprintf('pk%i(1)=min(raw_tm2(:,1))',pkc_id(i)));
                        pk_changes(pkc_id(i))=1;
                    end
                    if pk_para(pkc_id(i),2)>max(raw_tm2(:,1)) && pk_para(pkc_id(i),1)<max(raw_tm2(:,1)-10)
                        eval(sprintf('pk%i(2)=max(raw_tm2(:,1))',pkc_id(i)));
                        pk_changes(pkc_id(i))=1;
                    end
                end
                if ~isempty(find(pkc_changes,1)) && ~isempty(find(pk_changes,1))
                    errmsg=msgbox({'1.Input Wavenumber Range Is Outside Of The Data Range.';'Analysis For The Following Bands Will Be Skipped.';[];num2str(find(pkc_changes==1));[];'2.Input Wavenumber Range Is Partially Outside Of The Data Range.';'Wavenumber Range For The Following Bands Will Be Modified.';[];num2str(find(pk_changes==1))},'Warning','warn');
                    waitfor(errmsg);
                elseif find(pkc_changes==1)
                    errmsg=msgbox({'Input Wavenumber Range Is Outside Of The Data Range.';[];'Analysis For The Following Bands Will Be Skipped.';[];num2str(find(pkc_changes==1))},'Warning','warn');
                    waitfor(errmsg);
                elseif find(pk_changes==1)
                    errmsg=msgbox({'Input Wavenumber Range Is Partially Outside Of The Data Range.';[];'Wavenumber Range For The Following Bands Will Be Modified.';[];num2str(find(pk_changes==1))},'Warning','warn');
                    waitfor(errmsg);
                end      
                pk_para=[pk1;pk2;pk3;pk4;pk5;pk6;pk7;pk8;pk9;pk10];
                waitbar(0.95,waita,'Analyzing... 95%','Name','Please Wait');

        %find peak values for PO4
                if pk1c==1                    
                    try
                        BandAnalysis(raman,pk1(1),pk1(2),pk1(4),pk1(5),pk1(3));
                        xpk1I=pk1_3;
                        ypk1I=ypkI;
                        xpk1D=xpkD;
                        ypk1D=ypkD;
                        xpk1C=xpkC;
                        ypk1C=ypkC;
                        apk1=apkD;
                        ppk1=p;
                    catch
                        xpk1I=[];
                        ypk1I=[];
                        xpk1D=[];
                        ypk1D=[];
                        xpk1C=[];
                        ypk1C=[];
                        apk1=[];
                    end
                else
                    xpk1I=[];
                    ypk1I=[];
                    xpk1D=[];
                    ypk1D=[];
                    xpk1C=[];
                    ypk1C=[];
                    apk1=[];
                end

        %find peak values for Amide I
            %-general Peak
                if pk2c==1
                    try
                        BandAnalysis(raman,pk2(1),pk2(2),pk2(4),pk2(5),pk2(3));
                        xpk2I=pk2_3;
                        ypk2I=ypkI;
                        xpk2D=xpkD;
                        ypk2D=ypkD;
                        xpk2C=xpkC;
                        ypk2C=ypkC;
                        apk2=apkD;
                        ppk2=p;
                    catch
                        xpk2I=[];
                        ypk2I=[];
                        xpk2D=[];
                        ypk2D=[];
                        xpk2C=[];
                        ypk2C=[];
                        apk2=[];
                    end
            %-1640cm-1
                    BandAnalysis(raman,1620,1645,0.8,30,1640);
                    x1640I=1640;
                    y1640I=ypkI;
                    x1640D=xpkD;
                    y1640D=ypkD;
                    x1640C=xpkC;
                    y1640C=ypkC;
            %-1670cm-1
                    BandAnalysis(raman,1655,1710,0.8,25,1670);
                    x1670I=1670;
                    y1670I=ypkI;
                    x1670D=xpkD;
                    y1670D=ypkD;
                    x1670C=xpkC;
                    y1670C=ypkC;
                else
                    xpk2I=[];
                    ypk2I=[];
                    xpk2D=[];
                    ypk2D=[];
                    xpk2C=[];
                    ypk2C=[];
                    apk2=[];
                    x1640I=1640;
                    y1640I=[];
                    x1640D=[];
                    y1640D=[];
                    x1640C=[];
                    y1640C=[];
                    x1670I=1670;
                    y1670I=[];
                    x1670D=[];
                    y1670D=[];
                    x1670C=[];
                    y1670C=[];
                end

        %find peak value for CH2
                if pk3c==1
                    try
                        BandAnalysis(raman,pk3(1),pk3(2),pk3(4),pk3(5),pk3(3));
                        xpk3I=pk3_3;
                        ypk3I=ypkI;
                        xpk3D=xpkD;
                        ypk3D=ypkD;
                        xpk3C=xpkC;
                        ypk3C=ypkC;
                        apk3=apkD;
                        ppk3=p;
                    catch
                        xpk3I=[];
                        ypk3I=[];
                        xpk3D=[];
                        ypk3D=[];
                        xpk3C=[];
                        ypk3C=[];
                        apk3=[];
                    end
                else
                    xpk3I=[];
                    ypk3I=[];
                    xpk3D=[];
                    ypk3D=[];
                    xpk3C=[];
                    ypk3C=[];
                    apk3=[];
                end

        %find peak values for Amide III
            %-general Peak
                if pk4c==1
                    try
                        BandAnalysis(raman,pk4(1),pk4(2),pk4(4),pk4(5),pk4(3));
                        xpk4I=pk4_3;
                        ypk4I=ypkI;
                        xpk4D=xpkD;
                        ypk4D=ypkD;
                        xpk4C=xpkC;
                        ypk4C=ypkC;
                        apk4=apkD;
                        ppk4=p;
                    catch
                        xpk4I=[];
                        ypk4I=[];
                        xpk4D=[];
                        ypk4D=[];
                        xpk4C=[];
                        ypk4C=[];
                        apk4=[];
                    end
            %-1245cm-1
                    BandAnalysis(raman,1230,1260,0.8,15,1245);
                    x1245I=1245;
                    y1245I=ypkI;
                    x1245D=xpkD;
                    y1245D=ypkD;
                    x1245C=xpkC;
                    y1245C=ypkC;
            %-1270cm-1
                    BandAnalysis(raman,1260,1300,0.8,15,1270);
                    x1270I=1270;
                    y1270I=ypkI;
                    x1270D=xpkD;
                    y1270D=ypkD;
                    x1270C=xpkC;
                    y1270C=ypkC;
            %-1320cm-1
                    BandAnalysis(raman,1300,1335,0.8,20,1320);
                    x1320I=1320;
                    y1320I=ypkI;
                    x1320D=xpkD;
                    y1320D=ypkD;
                    x1320C=xpkC;
                    y1320C=ypkC;
                else
                    xpk4I=[];
                    ypk4I=[];
                    xpk4D=[];
                    ypk4D=[];
                    xpk4C=[];
                    ypk4C=[];
                    apk4=[];

                    x1245I=1245;
                    y1245I=[];
                    x1245D=[];
                    y1245D=[];
                    x1245C=[];
                    y1245C=[];
                    x1270I=1270;
                    y1270I=[];
                    x1270D=[];
                    y1270D=[];
                    x1270C=[];
                    y1270C=[];
                    x1320I=1320;
                    y1320I=[];
                    x1320D=[];
                    y1320D=[];
                    x1320C=[];
                    y1320C=[];
                end
                
        %find peak value for CO3
                if pk5c==1        
                    try
                        BandAnalysis(raman,pk5(1),pk5(2),pk5(4),pk5(5),pk5(3));
                        xpk5I=pk5_3;
                        ypk5I=ypkI;
                        xpk5D=xpkD;
                        ypk5D=ypkD;
                        xpk5C=xpkC;
                        ypk5C=ypkC;
                        apk5=apkD;
                        ppk5=p;
                    catch
                        xpk5I=[];
                        ypk5I=[];
                        xpk5D=[];
                        ypk5D=[];
                        xpk5C=[];
                        ypk5C=[];
                        apk5=[];
                    end
                else
                    xpk5I=[];
                    ypk5I=[];
                    xpk5D=[];
                    ypk5D=[];
                    xpk5C=[];
                    ypk5C=[];
                    apk5=[]; 
                end

        %find peak value for proline/hydroxyproline complex
                if pk6c==1
                    try
                        BandAnalysis(raman,pk6(1),pk6(2),pk6(4),pk6(5),pk6(3));
                        xpk6I=pk6_3;
                        ypk6I=ypkI;
                        xpk6D=xpkD;
                        ypk6D=ypkD;
                        xpk6C=xpkC;
                        ypk6C=ypkC;
                        apk6=apkD;
                        ppk6=p;
                    catch
                        xpk6I=[];
                        ypk6I=[];
                        xpk6D=[];
                        ypk6D=[];
                        xpk6C=[];
                        ypk6C=[];
                        apk6=[]; 
                    end
                else
                    xpk6I=[];
                    ypk6I=[];
                    xpk6D=[];
                    ypk6D=[];
                    xpk6C=[];
                    ypk6C=[];
                    apk6=[]; 
                end

        %find peak value for proline
                if pk7c==1
                    try
                        BandAnalysis(raman,pk7(1),pk7(2),pk7(4),pk7(5),pk7(3));
                        xpk7I=pk7_3;
                        ypk7I=ypkI;
                        xpk7D=xpkD;
                        ypk7D=ypkD;
                        xpk7C=xpkC;
                        ypk7C=ypkC;
                        apk7=apkD;
                        ppk7=p;
                    catch
                        xpk7I=[];
                        ypk7I=[];
                        xpk7D=[];
                        ypk7D=[];
                        xpk7C=[];
                        ypk7C=[];
                        apk7=[]; 
                    end
                else
                    xpk7I=[];
                    ypk7I=[];
                    xpk7D=[];
                    ypk7D=[];
                    xpk7C=[];
                    ypk7C=[];
                    apk7=[]; 
                end

        %find peak value for hydroxyproline
                if pk8c==1
                    try
                        BandAnalysis(raman,pk8(1),pk8(2),pk8(4),pk8(5),pk8(3));
                        xpk8I=pk8_3;
                        ypk8I=ypkI;
                        xpk8D=xpkD;
                        ypk8D=ypkD;
                        xpk8C=xpkC;
                        ypk8C=ypkC;
                        apk8=apkD;
                        ppk8=p;
                    catch
                        xpk8I=[];
                        ypk8I=[];
                        xpk8D=[];
                        ypk8D=[];
                        xpk8C=[];
                        ypk8C=[];
                        apk8=[]; 
                    end
                else
                    xpk8I=[];
                    ypk8I=[];
                    xpk8D=[];
                    ypk8D=[];
                    xpk8C=[];
                    ypk8C=[];
                    apk8=[]; 
                end

        %find peak values for xtra peak 1  
                if pk9c==1
                    try
                        BandAnalysis(raman,pk9(1),pk9(2),pk9(4),pk9(5),pk9(3));
                        xpk9I=pk9_3;
                        ypk9I=ypkI;
                        xpk9D=xpkD;
                        ypk9D=ypkD;
                        xpk9C=xpkC;
                        ypk9C=ypkC;
                        apk9=apkD;
                        ppk9=p;
                    catch
                        xpk9I=[];
                        ypk9I=[];
                        xpk9D=[];
                        ypk9D=[];
                        xpk9C=[];
                        ypk9C=[];
                        apk9=[];
                    end
                else
                    xpk9I=[];
                    ypk9I=[];
                    xpk9D=[];
                    ypk9D=[];
                    xpk9C=[];
                    ypk9C=[];
                    apk9=[];
                end

        %find peak values for xtra peak 2  
                if pk10c==1
                    try
                        BandAnalysis(raman,pk10(1),pk10(2),pk10(4),pk10(5),pk10(3));
                        xpk10I=pk10_3;
                        ypk10I=ypkI;
                        xpk10D=xpkD;
                        ypk10D=ypkD;
                        xpk10C=xpkC;
                        ypk10C=ypkC;
                        apk10=apkD;
                        ppk10=p;
                    catch
                        xpk10I=[];
                        ypk10I=[];
                        xpk10D=[];
                        ypk10D=[];
                        xpk10C=[];
                        ypk10C=[];
                        apk10=[];
                    end
                else
                    xpk10I=[];
                    ypk10I=[];
                    xpk10D=[];
                    ypk10D=[];
                    xpk10C=[];
                    ypk10C=[];
                    apk10=[];
                end

        %calculate Amide I ,CH2, and Amide III sub-peak ratios and
        %Proline/Hydroxyproline ratios
            %-1245/1270
                ratio1=y1245I/y1270I;
            %-1245/1454
                try
                    ratio2=y1245I/ypk3I;
                catch
                    ratio2=[];
                end
            %-1320/1454
                try
                    ratio3=y1320I/ypk3I;
                catch
                    ratio3=[];
                end
            %-1670/1640
                ratio4=y1670I/y1640I;
            %-pro/hyp
                try
                    ratio5=ypk8D/ypk7D;
                catch
                    ratio5=[];
                end
            %-mineral-to-matrix ratio
                try
                    ratio6=ypk1D/ypk3D;
                catch
                    ratio6=[];
                end
                try
                    ratio7=ypk1D/ypk2D;
                catch
                    ratio7=[];
                end
            %-carbonation
                try
                    carbn=ypk5D/ypk1D;
                catch
                    carbn=[];
                end
            %-crystallinity
                try
                    Crystallinity(raman);
                    crystlnt=1/peakwidth;
                catch
                    crystlnt=[];
                end
                waitbar(1,waita,'Done! 100%','Name','Analysis Complete');
                pause(0.5);
                delete(waita);

        %plot nomralized data
                F2=figure('units','normalized','outerposition',[0 0 1 1]);
                if size_y(2)>1
                    F2_2=subplot(2,1,2);
                    set(F2_2,'OuterPosition',[0,0.06,1,0.2]);
                    plot(x,sd,'Color','k');
                    axis([start_tm end_tm 0 max(sd*1.2)]);
                    title(['Sample ' name])
                    xlabel('Raman shift (cm^{-1})')
                    ylabel('Standard Deviation')
                    F2_1=subplot(2,1,1);
                    set(F2_1,'OuterPosition',[0,0.27,1,0.75]);
                end
                plot(x,norm_avg(:,2),'Color','k');
                axis([start_tm end_tm min(raman(:,2)) max(raman(:,2)*1.2)]);
                title(['Sample ' name])
                xlabel('Raman shift (cm^{-1})')
                ylabel('Intensity (normalized)')
                hold on;

        %show analysis area of each peak
                if pk2c==1
                    try
                        area(pk2_1:pk2_2,ppval(ppk2,pk2_1:pk2_2),'FaceColor','y');
                    catch
                    end
                end
                if pk3c==1
                    try
                        area(pk3_1:pk3_2,ppval(ppk3,pk3_1:pk3_2),'FaceColor','y');
                    catch
                    end
                end
                if pk4c==1
                    try
                        area(pk4_1:pk4_2,ppval(ppk4,pk4_1:pk4_2),'FaceColor','y');
                    catch
                    end
                end
                if pk6c==1
                    try
                        area(pk6_1:pk6_2,ppval(ppk6,pk6_1:pk6_2),'FaceColor','y');
                    catch
                    end
                end
                if pk7c==1
                    try
                        area(pk7_1:pk7_2,ppval(ppk7,pk7_1:pk7_2),'FaceColor','y');
                    catch
                    end
                end
                if pk8c==1
                    try
                        area(pk8_1:pk8_2,ppval(ppk8,pk8_1:pk8_2),'FaceColor','y');
                    catch
                    end
                end
                if pk5c==1
                    try
                        area(pk5_1:pk5_2,ppval(ppk5,pk5_1:pk5_2),'FaceColor','y');
                    catch
                    end
                end
                if pk1c==1
                    try
                        area(pk1_1:pk1_2,ppval(ppk1,pk1_1:pk1_2),'FaceColor','y');
                    catch
                    end
                end
                if pk9c==1
                    try
                        area(pk9_1:pk9_2,ppval(ppk9,pk9_1:pk9_2),'FaceColor','y');
                    catch
                    end
                end
                if pk10c==1
                    try
                        area(pk10_1:pk10_2,ppval(ppk10,pk10_1:pk10_2),'FaceColor','y');
                    catch
                    end
                end

        %plot centre of gravity
                if d1==1
                    if pk1c==1
                        try
                            L1=scatter(xpk1C,ypk1C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk1C xpk1C],[0 ypk1C],'LineStyle','--','Color','r');
                        catch
                        end
                    end
                    if pk5c==1
                        try
                            L1=scatter(xpk5C,ypk5C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk5C xpk5C],[0 ypk5C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk2c==1
                        try
                            L1=scatter(xpk2C,ypk2C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk2C xpk2C],[0 ypk2C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk3c==1
                        try
                            L1=scatter(xpk3C,ypk3C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk3C xpk3C],[0 ypk3C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk4c==1
                        try
                            L1=scatter(xpk4C,ypk4C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk4C xpk4C],[0 ypk4C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk6c==1
                        try
                            L1=scatter(xpk6C,ypk6C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk6C xpk6C],[0 ypk6C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk7c==1
                        try
                            L1=scatter(xpk7C,ypk7C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk7C xpk7C],[0 ypk7C],'LineStyle','--','Color','r');
                        catch
                        end
                    end 
                    if pk8c==1
                        try
                            L1=scatter(xpk8C,ypk8C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk8C xpk8C],[0 ypk8C],'LineStyle','--','Color','r');
                        catch
                        end
                    end      
                    if pk9c==1
                        try
                            L1=scatter(xpk9C,ypk9C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk9C xpk9C],[0 ypk9C],'LineStyle','--','Color','r');
                        catch
                        end
                    end
                    if pk10c==1
                        try
                            L1=scatter(xpk10C,ypk10C,'r','o','filled','DisplayName','centre of gravity');
                            line([xpk10C xpk10C],[0 ypk10C],'LineStyle','--','Color','r');
                        catch
                        end
                    end
                else
                    L1=[];
                end

        %plot peak maxima
                if d2==1
                    if pk1c==1
                        L2=scatter(xpk1D,ypk1D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk5c==1
                       L2=scatter(xpk5D,ypk5D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk2c==1
                        L2=scatter(xpk2D,ypk2D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk3c==1
                        L2=scatter(xpk3D,ypk3D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk4c==1
                        L2=scatter(xpk4D,ypk4D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk6c==1
                        L2=scatter(xpk6D,ypk6D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk7c==1
                        L2=scatter(xpk7D,ypk7D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk8c==1
                        L2=scatter(xpk8D,ypk8D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk9c==1
                        L2=scatter(xpk9D,ypk9D,'b','s','filled','DisplayName','peak maxima');
                    end
                    if pk10c==1
                        L2=scatter(xpk10D,ypk10D,'b','s','filled','DisplayName','peak maxima');
                    end
                else
                    L2=[];
                end

        %plot local maxima at assigned peak shit numbers
                if d3==1
                    if pk1c==1
                        L3=scatter(xpk1I,ypk1I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk5c==1
                        L3=scatter(xpk5I,ypk5I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk2c==1
                        L3=scatter(xpk2I,ypk2I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk3c==1
                        L3=scatter(xpk3I,ypk3I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk4c==1
                        L3=scatter(xpk4I,ypk4I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk6c==1
                        L3=scatter(xpk6I,ypk6I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk7c==1
                        L3=scatter(xpk7I,ypk7I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk8c==1
                        L3=scatter(xpk8I,ypk8I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk9c==1
                        L3=scatter(xpk9I,ypk9I,'m','s','filled','DisplayName','local maxima');
                    end
                    if pk10c==1
                        L3=scatter(xpk10I,ypk1I,'m','s','filled','DisplayName','local maxima');
                    end
                else
                    L3=[];
                end

        %plot selcted shift peaks
                if d4==1
                    L4=scatter(x1245I,y1245I,'g','^','filled','DisplayName','specified shift maxima');
                    scatter(x1270I,y1270I,'g','^','filled');
                    scatter(xpk3I,ypk3I,'g','^','filled');
                    scatter(x1320I,y1320I,'g','^','filled');
                    scatter(x1670I,y1670I,'g','^','filled');
                    scatter(x1640I,y1640I,'g','^','filled');
                else
                  L4=[];
                end

        %assign peak names
                space=max(raman(:,2))*0.05;
                if pk1c==1
                    txt1=pk1a;
                    t1=text(xpk1D,ypk1D+space,txt1);
                end
                if pk5c==1
                    txt2=pk5a;
                    t1=text(xpk5D,ypk5D+space,txt2);
                end
                if pk2c==1
                    txt3=pk2a;
                    t3=text(xpk2D,ypk2D+space,txt3);
                end
                if pk3c==1
                    txt4=pk3a;
                    t4=text(xpk3D,ypk3D+space,txt4);
                end
                if pk4c==1
                    txt5=pk4a;
                    t5=text(xpk4D,ypk4D+space,txt5);
                end
                if pk6c==1
                    txt6=pk6a;
                    t6=text(xpk6D,ypk6D+space,txt6);
                end
                if isequal(load_bio_para,'On')
                    if pk6c==0
                        if pk7c==1
                            txt7=pk7a;
                            t7=text(xpk7D,ypk7D+space,txt7);
                        end
                        if pk8c==1
                            txt8=pk8a;
                            t8=text(xpk8D,ypk8D+space,txt8);
                        end
                    end
                else
                    if pk7c==1
                        txt7=pk7a;
                        t7=text(xpk7D,ypk7D+space,txt7);
                    end
                    if pk8c==1
                        txt8=pk8a;
                        t8=text(xpk8D,ypk8D+space,txt8);
                    end
                end
                if pk9c==1
                    txt9=pk9a;
                    t9=text(xpk9D,ypk9D+space,txt9);
                end
                if pk10c==1
                    txt10=pk10a;
                    t10=text(xpk10D,ypk10D+space,txt10);
                end

        %display results
                result1=['1245/1270 ratio = ',num2str(ratio1)];
                result2=['1245/1454 ratio = ',num2str(ratio2)];
                result3=['1320/1454 ratio = ',num2str(ratio3)];
                result4=['1670/1640 ratio = ',num2str(ratio4)];
                result5=['Pro/Hyp ratio = ',num2str(ratio5)];
                result6=['ProHyp COG = ',num2str(xpk6C)];
                result7=['Amide III COG = ',num2str(xpk4C)];
                result8=['CH2 COG = ',num2str(xpk3C)];
                result9=['Amide I COG = ',num2str(xpk2C)];
                if sample_type==1
                    result10=['PO4 COG = ',num2str(xpk1C)];
                else
                    result10=['PO4 COG = ',num2str(0)];
                end
                result11=['M-M ratio PO4/CH2 = ',num2str(ratio6)];
                result12=['M-M ratio PO4/Amide I = ',num2str(ratio7)];
                result13=['Type-B Carbonation = ',num2str(carbn)];
                result14=['Mineral crystallinity = ',num2str(crystlnt)];
                if sample_type==1
                    zz=[ratio1,ratio2,ratio3,ratio4,ratio5,xpk6C,xpk4C,xpk3C,xpk2C,xpk1C,ratio6,ratio7,carbn,crystlnt];
                else
                    zz=[ratio1,ratio2,ratio3,ratio4,ratio5,xpk6C,xpk4C,xpk3C,xpk2C,0,ratio6,ratio7,carbn,crystlnt];
                end
                disp(name);
                disp(result1);
                disp(result2);
                disp(result3);
                disp(result4);
                disp(result5);
                disp(result6);
                disp(result7);
                disp(result8);
                disp(result9);
                if pk1c==1
                    try
                        disp(result10);
                        disp(result11);
                        disp(result12);
                        L5=line([xwidth1 xwidth2],[halfheight halfheight],'LineStyle','-','Color','r','DisplayName','crystallinity');
                        disp(result13);
                        disp(result14);
                    catch
                        L5=[];
                    end
                else
                    L5=[];
                end
                try
                    legend([L1 L2 L3 L4 L5]);
                catch
                end

        %make folder for results
                foldername=['Results_' name];
                cd(newdir);
                mkdir([newdir '\' foldername]);

        %perform measurements on isolated peaks
                if pkana==1
                    waitb=waitbar(0,'Analyzing Individual Band... 0%','Name','Please Wait');
                    pkcs=[pk1c,pk2c,pk3c,pk4c,pk5c,pk6c,pk7c,pk8c,pk9c,pk10c];
                    if isequal(load_bio_para,'On')
                        if pk3c==1 || pk4c==1
                           pkcs(3)=1; pkcs(4)=0;
                        end
                        if pk6c==1 || pk7c==1 || pk8c==1
                           pkcs(6)=1; pkcs(7)=0; pkcs(8)=0;
                        end
                    end
                    tmranges=[pk1_6,pk1_7;pk2_6,pk2_7;pk3_6,pk3_7;pk4_6,pk4_7;pk5_6,pk5_7;pk6_6,pk6_7;pk7_6,pk7_7;pk8_6,pk8_7;pk9_6,pk9_7;pk10_6,pk10_7];
                    marker=[d1,d2,d3];
                    pkcsid=find(pkcs==1);
                    Peak={pk_names{1};pk_names{2};pk_names{3};pk_names{4};pk_names{5};pk_names{6};pk_names{7};pk_names{8};pk_names{9};pk_names{10}};
                    Start_Shift=cell(10,1);
                    End_Shift=cell(10,1);
                    Peak_Shift=cell(10,1);
                    Smoothing_Factor=cell(10,1);
                    HWHM=cell(10,1);
                    Area=cell(10,1);
                    COG_x=cell(10,1);
                    COG_y=cell(10,1);
                    Maxima_drv_x=cell(10,1);
                    Maxima_drv_y=cell(10,1);
                    Maxima_interp_x=cell(10,1);
                    Maxima_interp_y=cell(10,1);
                    crystallinity=cell(10,1);
                    for i=1:numel(pkcsid)
                       a=pkcsid(i);
                       tmrange=tmranges(a,:);
                       BandIsolation(load_bio_para,pk_para,pk_names,marker,tmrange,x,smt_yavg,name,a);
                       figure(waitb);
                       for ii=1:numel(pkcid_i)
                           b=pkcid_i(ii);
                           Start_Shift{b,1}=pkcresults_i{2,ii};
                           End_Shift{b,1}=pkcresults_i{3,ii};
                           Peak_Shift{b,1}=pkcresults_i{4,ii};
                           Smoothing_Factor{b,1}=pkcresults_i{5,ii};
                           HWHM{b,1}=pkcresults_i{6,ii};
                           Area{b,1}=pkcresults_i{7,ii};
                           COG_x{b,1}=pkcresults_i{8,ii};
                           COG_y{b,1}=pkcresults_i{9,ii};
                           Maxima_drv_x{b,1}=pkcresults_i{10,ii};
                           Maxima_drv_y{b,1}=pkcresults_i{11,ii};
                           Maxima_interp_x{b,1}=pkcresults_i{12,ii};
                           Maxima_interp_y{b,1}=pkcresults_i{13,ii};
                           crystallinity{b,1}=pkcresults_i{14,ii};
                       end        
                       perct=0.9/numel(pkcsid)*i;
                       waitbar(perct,waitb,['Analyzing Individual Band... ' num2str(perct*100) '%'],'Name','Please Wait');
                    end
                    waitbar(0.99,waitb,'Finishing Up... 99%','Name');
                    Tx=table(Peak,Start_Shift,End_Shift,Peak_Shift,Smoothing_Factor,HWHM,Area,COG_x,COG_y,Maxima_drv_x,Maxima_drv_y,Maxima_interp_x,Maxima_interp_y,crystallinity);
                    filenamex = [newdir '\' foldername '\Measurements_Isolated.xlsx'];
                    writetable(Tx,filenamex,'Sheet',1,'Range','A1');
                    waitbar(1,waitb,'Done! 100%','Name','Analysis Complete');
                    pause(0.5);
                    delete(waitb);
                end

        %curve fitting
                if run_curve_fit==1
                    settings=[remove_background,fix_location,type_locs,fun_type,frac,algo];
                    results_b=zeros(1,1000);
                    size_cf=zeros(1,100);
                    peaknamescf=cell(1,100);
                    resnorms=zeros(1,100);
                    n=0;
                    while run_curve_fit==1
                        n=n+1;
                        F3=figure('units','normalized','outerposition',[0 0 1 1]);
                        plot(x,norm_avg(:,2),'Color','k');
                        axis([min(raman(:,1)) max(raman(:,1)) min(raman(:,2)) max(raman(:,2)+0.5)]);
                        title({['Sample ' name];[];'Use TWO Mouse-Clicks to Define the Lower and Upper Boundaries of the Band'})
                        xlabel('Raman shift (cm^{-1})')
                        ylabel('Intensity (normalized)')
                        hold on;
                        i=msgbox('Please Define Boundaries for Curve Fitting. Then Input Start Conditions Using the Next Figure. Each Sub-Curve is Defined by THREE Points.','Curve Fitting Inputs','help');
                        waitfor(i);
                        locscf=zeros(2,1);
                        intncf=zeros(2,1);
                        for i=1:2
                            [locscfi,intncfi]=ginput(1);
                            xline(locscfi,'k','LineStyle','--');
                            locscf(i)=locscfi;
                            intncf(i)=intncfi;
                        end
                        close(F3);                     
                        [a,~]=find(norm_avg(:,1)>min(locscf) & norm_avg(:,1)<max(locscf));
                        raw=norm_avg(a,:);
                        CurveFit(name,raw,settings,pk_names,pk_para);
                        size_cfi=numel(b)/3;
                        i=nnz(results_b);
                        for ii=1:numel(b)                          
                            results_b(i+ii)=b(ii);
                        end
                        results_b(find(results_b==0,1):end)=[];
                        peaknamescf{n}=peaknamecf;
                        peaknamescf(find(cellfun(@isempty,peaknamescf),1):end)=[];
                        resnorms(n)=resnorm;
                        resnorms(find(resnorms==0,1):end)=[];
                        size_cf(n)=size_cfi;
                        size_cf(find(size_cf==0,1):end)=[];
                        i=questdlg('Do You Want to Perform Curve Fitting on Another Band?','Curve Fitting','YES','NO','YES');
                        switch i
                            case 'YES'
                                run_curve_fit=1;
                            case 'NO'
                                run_curve_fit=0;
                        end
                    end
                end


    %RESULTS PREPARATION
                wait1=waitbar(0,'Organizing Results into Tables...','Name','Please Wait');

        %generate table for analysis settings
                if  bg_rmv==1
                    bg_rmva='Modified Polynomial';
                else
                    bg_rmva='Polynomial';
                end

                if norm_type==1
                    norm_typea='Vectoring';
                elseif norm_type==2
                    norm_typea='SNV';
                elseif norm_type==3
                    norm_typea='Min-Max';
                else
                    norm_typea='Reference Peak';
                end
                if norm_type==4                   
                    avg_ids=mean(x_ids(:,1));
                    avg_para=zeros(1,10);
                    for i=1:10
                        avg_para(i)=pk_para(i,3);
                    end
                    [~,id]=min(abs(avg_para-avg_ids));
                    peakname=pk_names{id};                   
                else
                    peakname={''};
                end
                if override==0
                    overridea='NO';
                else
                    overridea='YES';
                end
                if override==1
                    if type==0
                        typea='Pure Organic';
                    else
                        typea='Mineralized';
                    end
                else
                    typea='';
                end
                if remove_background==0
                    remove_backgrounda='NO';
                else
                    remove_backgrounda='YES';
                end
                if fix_location==0
                    fix_locationa='NO';
                else
                    fix_locationa='YES';
                end
                if fun_type==0
                    fun_typea='Gaussian';
                elseif fun_type==1
                    fun_typea='Lorentzian';
                else
                    fun_typea='G-L Mix';
                end
                if fun_type==2
                    fraca=[num2str(frac) ' Gauss'];
                else
                    fraca='';
                end
                if algo==0
                    algoa='Trust-Region-Reflective';
                else
                    algoa='Levenberg-Marquardt';
                end
                Si_Calibration_Shift={'';num2str(wavenumber_input)};
                Spectrum_Trim={'Start','End';num2str(start_tm),num2str(end_tm)};
                Smoothing={'Order','Window Size';num2str(order_smt),num2str(size_smt)};
                Background_Removal={'Method','Order';bg_rmva,num2str(order_bk)};
                Normalization={'','';norm_typea,peakname};
                Sample_Override={'','Override Type';overridea,typea};
                Curve_Fitting={'Background Removal','Fix Peak Location','Fitting Function','','Fitting Algorithm';...
                remove_backgrounda,fix_locationa,fun_typea,fraca,algoa};
                T1=table(Si_Calibration_Shift,Spectrum_Trim,Smoothing,Background_Removal,Normalization,Sample_Override,Curve_Fitting);

        %generate table for spectrum measurements
                Peak={pk_names{1};pk_names{2};pk_names{3};pk_names{4};pk_names{5};pk_names{6};pk_names{7};pk_names{8};pk_names{9};pk_names{10}};
                Start_Shift={num2str(pk1_1);num2str(pk2_1);num2str(pk3_1);num2str(pk4_1);num2str(pk5_1);num2str(pk6_1);num2str(pk7_1);num2str(pk8_1);num2str(pk9_1);num2str(pk10_1)};
                End_Shift={num2str(pk1_2);num2str(pk2_2);num2str(pk3_2);num2str(pk4_2);num2str(pk5_2);num2str(pk6_2);num2str(pk7_2);num2str(pk8_2);num2str(pk9_2);num2str(pk10_2)};
                Peak_Shift={num2str(pk1_3);num2str(pk2_3);num2str(pk3_3);num2str(pk4_3);num2str(pk5_3);num2str(pk6_3);num2str(pk7_3);num2str(pk8_3);num2str(pk9_3);num2str(pk10_3)};
                Smoothing_Factor={num2str(pk1_4);num2str(pk2_4);num2str(pk3_4);num2str(pk4_4);num2str(pk5_4);num2str(pk6_4);num2str(pk7_4);num2str(pk8_4);num2str(pk9_4);num2str(pk10_4)};
                HWHM={num2str(pk1_5);num2str(pk2_5);num2str(pk3_5);num2str(pk4_5);num2str(pk5_5);num2str(pk6_5);num2str(pk7_5);num2str(pk8_5);num2str(pk9_5);num2str(pk10_5)};
                Area={num2str(apk1);num2str(apk2);num2str(apk3);num2str(apk4);num2str(apk5);num2str(apk6);num2str(apk7);num2str(apk8);num2str(apk9);num2str(apk10)};
                COG_x={num2str(xpk1C);num2str(xpk2C);num2str(xpk3C);num2str(xpk4C);num2str(xpk5C);num2str(xpk6C);num2str(xpk7C);num2str(xpk8C);num2str(xpk9C);num2str(xpk10C)};
                COG_y={num2str(ypk1C);num2str(ypk2C);num2str(ypk3C);num2str(ypk4C);num2str(ypk5C);num2str(ypk6C);num2str(ypk7C);num2str(ypk8C);num2str(ypk9C);num2str(ypk10C)};
                Maxima_drv_x={num2str(xpk1D);num2str(xpk2D);num2str(xpk3D);num2str(xpk4D);num2str(xpk5D);num2str(xpk6D);num2str(xpk7D);num2str(xpk8D);num2str(xpk9D);num2str(xpk10D)};
                Maxima_drv_y={num2str(ypk1D);num2str(ypk2D);num2str(ypk3D);num2str(ypk4D);num2str(ypk5D);num2str(ypk6D);num2str(ypk7D);num2str(ypk8D);num2str(ypk9D);num2str(ypk10D)};
                Maxima_interp_x={num2str(xpk1I);num2str(xpk2I);num2str(xpk3I);num2str(xpk4I);num2str(xpk5I);num2str(xpk6I);num2str(xpk7I);num2str(xpk8I);num2str(xpk9I);num2str(xpk10I)};
                Maxima_interp_y={num2str(ypk1I);num2str(ypk2I);num2str(ypk3I);num2str(ypk4I);num2str(ypk5I);num2str(ypk6I);num2str(ypk7I);num2str(ypk8I);num2str(ypk9I);num2str(ypk10I)};
                crystallinity={num2str(crystlnt);'';'';'';'';'';'';'';'';''};
                T2=table(Peak,Start_Shift,End_Shift,Peak_Shift,Smoothing_Factor,HWHM,Area,COG_x,COG_y,Maxima_drv_x,Maxima_drv_y,Maxima_interp_x,Maxima_interp_y,crystallinity);

        %generate table for curve fitting results
                if lastrun_curve_fit==1
                    Fitted_Peaks=cell(100,1);
                    for i=1:n
                        Fitted_Peaks(i+1,1)=peaknamescf(i);
                    end
                    Fitted_Peaks(n+2:end)=[];
                    n_max=max(size_cf);
                    T3=cell(numel(Fitted_Peaks),n_max*3+1);
                    for i=1:numel(Fitted_Peaks)
                        T3{i,1}=Fitted_Peaks{i};
                    end                   
                    for i=1:n_max
                        curvei=cell(n+1,3);
                        for ii=2:n+1
                            if ii-1==1
                                f_sample=0;
                            else
                                f_sample=0;
                                for iii=2:ii-1
                                    f_samplei=3*size_cf(iii-1);
                                    f_sample=f_sample+f_samplei;
                                end
                            end
                            n_data=0;
                            for iiii=1:ii-1
                                n_datai=3*size_cf(iiii);
                                n_data=n_data+n_datai;
                            end
                            if f_sample+3*i-2>n_data
                                m1='';
                            else
                                m1=num2str(results_b(f_sample+3*i-2));
                            end
                            if f_sample+3*i-1>n_data
                                m2='';
                            else
                                m2=num2str(results_b(f_sample+3*i-1));
                            end
                            if f_sample+3*i>n_data
                                m3='';
                            else
                                m3=num2str(results_b(f_sample+3*i));
                            end
                            eval(sprintf('curve%d(ii,:)={m1,m2,m3};',i));
                        end
                        eval(sprintf('curve%d(1,1)={''Peak Height''};',i));
                        eval(sprintf('curve%d(1,2)={''Peak Shift''};',i));
                        eval(sprintf('curve%d(1,3)={''HWHM''};',i));
                        T3i=eval(sprintf('curve%d',i));
                        for ii=1:3
                            iii=3*i-2;
                            for iiii=1:numel(Fitted_Peaks)
                                T3{iiii,ii+iii}=T3i{iiii,ii};
                            end
                        end
                        eval(sprintf('curve%d={};',i))
                    end
                    T3=cell2table(T3);
                    for i=1:n_max
                        T3=mergevars(T3,[i+1 i+2 i+3]);
                    end
                end

        %generate table for fitting residual
                if lastrun_curve_fit==1
                T4=table(residual);
                end

        %generate table for processed spectrum
                T5=[table(raman) table(stdev)];
                if lastrun_curve_fit==1
                    waitbar(.2,wait1,'Saving Analysis Parameters...','Name','Please Wait');
                    filename1 = [newdir '\' foldername '\Parameters.xlsx'];
                    writetable(T1,filename1,'Sheet',1,'Range','A1');
                    waitbar(.4,wait1,'Saving Measurement Results...','Name','Please Wait');
                    filename2 = [newdir '\' foldername '\Measurements.xlsx'];
                    writetable(T2,filename2,'Sheet',1,'Range','A1');
                    waitbar(.6,wait1,'Saving Curve Fitting Results...','Name','Please Wait');
                    filename3 = [newdir '\' foldername '\FittedCurves.xlsx'];
                    writetable(T3,filename3,'Sheet',1,'Range','A1');
                    filename4 = [newdir '\' foldername '\FittingResidual.xlsx'];
                    writetable(T4,filename4,'Sheet',1,'Range','A1');
                    waitbar(.8,wait1,'Saving Processed Raman Spectrum...','Name','Please Wait');
                    filename5 = [newdir '\' foldername '\FinalSpectrum.xlsx'];
                    writetable(T5,filename5,'Sheet',1,'Range','A1');
                    waitbar(1,wait1,'Complete','Name','Saving Complete');
                    pause(0.5)
                    delete(wait1);
                else
                    waitbar(.25,wait1,'Saving Analysis Parameters...','Name','Please Wait');
                    filename1 = [newdir '\' foldername '\Parameters.xlsx'];
                    writetable(T1,filename1,'Sheet',1,'Range','A1');
                    waitbar(.50,wait1,'Saving Measurement Results...','Name','Please Wait');
                    filename2 = [newdir '\' foldername '\Measurements.xlsx'];
                    writetable(T2,filename2,'Sheet',1,'Range','A1');
                    waitbar(.75,wait1,'Saving Processed Raman Spectrum...','Name','Please Wait');
                    filename3 = [newdir '\' foldername '\FinalSpectrum.xlsx'];
                    writetable(T5,filename3,'Sheet',1,'Range','A1');
                    waitbar(1,wait1,'Complete','Name','Saving Complete');
                    pause(0.5)
                    delete(wait1);
                end
           
        %check Finishing Condition
                i=questdlg('Do You Want to Analyze Another Sample?','Repeating Analysis','YES','YES (Update Settings)','NO (Finish)','YES');
                switch i
                    case 'YES'
                        repeat=1; newpara=0;run_curve_fit=lastrun_curve_fit; auto_cal=0;
                    case 'YES (Update Settings)'
                        repeat=1; newpara=1; run_curve_fit=1;
                    case 'NO (Finish)'
                        repeat=0;
                end
            end
            if abort==0 && break_out1==0 && break_out2==0
                msg=msgbox('Analysis Complete.','Success','help');
                waitfor(msg)
            end
        catch error
            
        %display error message
            errstack=error.stack;
            errid=numel(errstack);
            stackd=errstack(max(errid));    
            msgd1=stackd.name;
            msgd2=stackd.line;
            msgd3=error.message;
            if msgd2==142
            else
                i=msgbox({'Analysis Terminated! RamanAnalyzer Will Restart!';[];'Error in:';['file:' msgd1];['line:' num2str(msgd2)];[];['Message: ' msgd3]},'Error','error');
                waitfor(i);

            %save error log
                Te=cell(20,6);
                if errid==0
                    msg='Error Message is Empty.';
                    Te=(msg);
                else
                    s1=' | File:';
                    s2=' | Name:';
                    s3=' | Line:';
                    for ii=1:errid
                        stacki=errstack(ii);
                        Tei={s1 stacki.file s2 stacki.name s3 num2str(stacki.line)};
                        for iii=1:6
                        Te{ii,iii}=Tei{iii};
                        end
                    end
                end
                Te=cell2table(Te);
                try
                    foldername=['Results_' name];
                    filenameerr = [newdir '\' foldername '\error_log.xlsx'];
                    writetable(Te,filenameerr,'Sheet',1,'Range','A1');
                catch 
                end
            end
        end
    else
    end
    
    %COMPETE, RELAUNCH THE LAUNCHER
    clear;
    break_out1=0;
    break_out2=0;
    launcher=Launcher;
    window_close=0;
    launcher_status=1;
    load_bio_para='On';
    spectrum_analysis=0;
    waitfor(launcher)
end