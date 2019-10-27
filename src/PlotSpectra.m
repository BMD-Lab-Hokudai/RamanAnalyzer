function PlotSpectra(single_graph,apply_calibration,wavenumber_ref)

    try
        
%load file
        [file,path]=uigetfile('*.txt','Select One or More Files to Plot','MultiSelect','on');
        cd(path);
        file = cellstr(file);
        id='MATLAB:handle_graphics:exceptions:SceneNode';
        warning('off',id);
        if isequal(apply_calibration, 'On')
            i=msgbox('Please Select File for Calibration.','Get File','help');
            waitfor(i);
            Calibration;
        else
            wavenumber_cal = wavenumber_ref;
        end 
        
%determine plotting type and create figure if needed
        if isequal(single_graph, 'On')
            f=figure;
            xlabel('Raman shift (cm^{-1})');
            ylabel('Intensity (cps)');
            title([path(end-7:end),' spectra']);
            xticks('auto');
            xtickangle(45);
            hold on
            L={};
        else
        end
        
%plot spectrum/spectra
        for i=1:numel(file)
            filename=fullfile(path,file{i});
            try
                raw=dlmread(filename);
            catch
                fID=fopen(filename);
                txtdata=textscan(fID,'%f%f','HeaderLines',1,'CollectOutput',1);
                fclose(fID);
                raw=txtdata{1};
            end
             check_format=isnan(raw);
    
            if isempty(raw)
                if isequal(single_graph, 'On')
                    close(f);
                end
                errmsg=msgbox('.txt File Can Only Have Less Than Two Lines Of Header.','Check File Format','error');
                waitfor(errmsg);
                return
            elseif ~isempty(find(check_format,1))
                if isequal(single_graph, 'On')
                    close(f);
                end
                errmsg=msgbox('More Than Two Columns Is Detected In The .txt File.','Check File Format','error');
                waitfor(errmsg);
                return
            end            
            raw(:,1) = raw(:,1) - (wavenumber_cal - wavenumber_ref);
            if isequal(single_graph,'On')
                Li=file(i);
                L=cat(1,L,Li);
                plot(raw(:,1),raw(:,2));
            else
                filetitle=file(i);
                figure;
                plot(raw(:,1),raw(:,2));
                xlabel('Raman shift (cm^{-1})');
                ylabel('Intensity (cps)');
                xticks('auto');
                xtickangle(45);
                hold on;
                title([path(end-7:end),filetitle{1}]);
            end
        end
        if isequal(single_graph,'On')
            legend(L)
        end
    catch
    end
    clear;
end