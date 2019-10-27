function CosmicRayRemoval(x,y_raw,colnmbr)

%ask for input
    if numel(colnmbr)==0        
        for i=1:ceil(numel(y_raw(1,:))/10)
            ii=10*i-9;         
            try
                figure('units','normalized','outerposition',[0 0 1 1]);
                subplot(5,2,1),plot(x,y_raw(:,ii)),title(ii);
                subplot(5,2,2),plot(x,y_raw(:,ii+1)),title(ii+1);
                subplot(5,2,3),plot(x,y_raw(:,ii+2)),title(ii+2);
                subplot(5,2,4),plot(x,y_raw(:,ii+3)),title(ii+3);
                subplot(5,2,5),plot(x,y_raw(:,ii+4)),title(ii+4);
                subplot(5,2,6),plot(x,y_raw(:,ii+5)),title(ii+5);
                subplot(5,2,7),plot(x,y_raw(:,ii+6)),title(ii+6);
                subplot(5,2,8),plot(x,y_raw(:,ii+7)),title(ii+7);
                subplot(5,2,9),plot(x,y_raw(:,ii+8)),title(ii+8);
                subplot(5,2,10),plot(x,y_raw(:,ii+9)),title(ii+9);
            catch
            end
            select_spectra=1;
            while select_spectra==1
                prompt='Enter Plot Numbers for Cosmic Ray Removal. Seperate Each Number with Space. Leave Blank If NONE.';
                dlgtitle='Cosmic Ray Removal';
                iii=inputdlg(prompt,dlgtitle);
                if numel(iii)==0 || isempty(iii{1})
                    select_spectra=0;
                else
                    iii=split(iii,{', ',',',' '});
                    iiii=str2double(iii);
                    if max(isnan(iiii))==1 || min(iiii)<1 || max(iiii)>numel(y_raw(1,:)) || max(rem(iiii,1)~=0)==1
                        errmsg1=msgbox({'Invalid Entry';[];'Please try again.'},'Warning','warn');
                        waitfor(errmsg1); 
                    else
                        colnmbr=cat(1,colnmbr,iiii);
                        select_spectra=0;
                    end 
                end                        
            end 
            close;
        end
    end
    
%remove spikes in selected spectra
    if numel(colnmbr)==0
        runcr=0;
    end
    y_raw_n=[];
    for i=1:numel(colnmbr)
        y_cri=y_raw(:,colnmbr(i));
        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on
        title(colnmbr(i));
        plot(x,y_cri);
        waitfor(msgbox('Please Click the Peak-Point of Unwanted Spikes. Press "Enter" to Finish'));
        
        pick_spikes=1;
        n=0; 
        x_spike=zeros(100,1);
        while pick_spikes==1
            n=n+1;
           
            try
                [x_spikei,~]=ginput(1);
                x_spike(n)=x_spikei;
                xline(x_spikei,'k','LineStyle','--','Label',n);
            catch
                break
            end
        end 
        x_spike(find(x_spike==0,1):end)=[];
        close;
        error=0;
        for n=1:numel(x_spike)
            try
                [x_id1,~]=find(x>(x_spike(n)-10) & x<(x_spike(n)+10));
                x_pk=x(x_id1);
                y_pk=y_cri(x_id1);
                [~,x_id2]=findpeaks(y_pk,'SortStr','descend','NPeaks',1);
                [x_id3,~]=find(x>(x_pk(x_id2)-10) & x<(x_pk(x_id2)+10));
                x_cr=x(x_id3);
                y_cr=y_cri(x_id3);
                spike=csaps(x_cr,y_cr,1);
                spike_2dv=fnder(spike,2);
                [~,x_id4]=findpeaks(ppval(spike_2dv,x_cr),'SortStr','descend','NPeaks',2);
                x_intrp=(min(x_id4)-1:max(x_id4)+1).';
                x_pts=[min(x_intrp)-1;max(x_intrp)+1];
                cr_pts=[x_cr(x_pts) y_cr(x_pts)];
                y_intrp=interp1(cr_pts(:,1),cr_pts(:,2),x_cr(x_intrp));
                y_raw(x_id3(x_intrp),colnmbr(i))=y_intrp;
            catch
                error=1;
            end
        end      
        if error==1
            errmsg2=msgbox({'Cosmic Ray Removal Tool could not correct some of the selected peaks';[];'The affected peak(s) will be skipped.'},'Warning','warn');
            waitfor(errmsg2);
        end
        y_raw_n=cat(2,y_raw_n,y_raw(:,colnmbr(i)));
    end
    
%check results
    ii=0;
    for i=1:ceil(numel(colnmbr)/10)
        ii=ii+1;           
        try
            figure('units','normalized','outerposition',[0 0 1 1]);
            subplot(5,2,1),plot(x,y_raw_n(:,ii)),title(colnmbr((i-1)*10+ii));
            subplot(5,2,2),plot(x,y_raw_n(:,ii+1)),title(colnmbr((i-1)*10+ii+1));
            subplot(5,2,3),plot(x,y_raw_n(:,ii+2)),title(colnmbr((i-1)*10+ii+2));
            subplot(5,2,4),plot(x,y_raw_n(:,ii+3)),title(colnmbr((i-1)*10+ii+3));
            subplot(5,2,5),plot(x,y_raw_n(:,ii+4)),title(colnmbr((i-1)*10+ii+4));
            subplot(5,2,6),plot(x,y_raw_n(:,ii+5)),title(colnmbr((i-1)*10+ii+5));
            subplot(5,2,7),plot(x,y_raw_n(:,ii+6)),title(colnmbr((i-1)*10+ii+6));
            subplot(5,2,8),plot(x,y_raw_n(:,ii+7)),title(colnmbr((i-1)*10+ii+7));
            subplot(5,2,9),plot(x,y_raw_n(:,ii+8)),title(colnmbr((i-1)*10+ii+8));
            subplot(5,2,10),plot(x,y_raw_n(:,ii+9)),title(colnmbr((i-1)*10+ii+9));
        catch
        end
        answer=questdlg('Run it again?');
        switch answer
            case 'Yes'
                runcr=1;
            case 'No'
                runcr=0;
            case 'Cancel'
                runcr=0;
        end
        if runcr==1
            if numel(colnmbr)>1
                colnmbr=[];
                select_spectra=1;
                while select_spectra==1 
                    prompt='Please enter plot numbers';
                    dlgtitle='Cosmic Ray Removal';
                    iii=inputdlg(prompt,dlgtitle);
                    iii=split(iii,{', ',',',' '});
                    iiii=str2double(iii);
                    if max(isnan(iiii))==1 || min(iiii)<1 || max(iiii)>numel(y_raw(1,:)) || max(rem(iiii,1)~=0)==1
                        errmsg1=msgbox({'Invalid Entry';[];'Please try again.'},'Warning','warn');
                        waitfor(errmsg1); 
                    else
                        colnmbr=cat(1,colnmbr,iiii);
                        select_spectra=0;
                        close;
                    end 
                end
            else
                close;
            end
        else
            close;
        end       
    end
    
%pass results to 'caller'
    assignin('caller','y_raw',y_raw);
    assignin('caller','runcr',runcr);
    assignin('caller','colnmbr',colnmbr);
end