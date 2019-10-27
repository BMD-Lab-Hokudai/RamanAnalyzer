function BandIsolation(load_bio_para,pkpara,pk_names,marker,tmrange,x,y,name,i)

%% Initialize

    pkc=[0 0 0 0 0 0 0 0 0 0];
    pkc(i)=1;
    if isequal(load_bio_para,'On')
        if i==3
            pkc(4)=1;
        end
        if i==6
            pkc(7)=1; pkc(8)=1;
        end
    end
    pkcid=find(pkc==1);
    
    
%% Set Default Parameters

    %trimming
    trim=1; %'1'=apply trim, '0'=NOT apply trim
        %-start and end point
    start_tm=tmrange(1);
    end_tm=tmrange(2);

    %background removal
        %-Method, '1'=Modified Polynomial, '0'=Polynomial
    bg_rmv=1;
        %-Order of polynomial
    order_bk=1;

    %peaks Parameters [shift_start, shift_end, shift_peak, smooth factor, HWHM, band isolation start, band isolation end]
    pk1_1=pkpara(1,1);pk1_2=pkpara(1,2);pk1_3=pkpara(1,3);pk1_4=pkpara(1,4);pk1_5=pkpara(1,5);
    pk1a=pk_names{1};
    pk2_1=pkpara(2,1);pk2_2=pkpara(2,2);pk2_3=pkpara(2,3);pk2_4=pkpara(2,4);pk2_5=pkpara(2,5);
    pk2a=pk_names{2};
    pk3_1=pkpara(3,1);pk3_2=pkpara(3,2);pk3_3=pkpara(3,3);pk3_4=pkpara(3,4);pk3_5=pkpara(3,5);
    pk3a=pk_names{3};
    pk4_1=pkpara(4,1);pk4_2=pkpara(4,2);pk4_3=pkpara(4,3);pk4_4=pkpara(4,4);pk4_5=pkpara(4,5);
    pk4a=pk_names{4};
    pk5_1=pkpara(5,1);pk5_2=pkpara(5,2);pk5_3=pkpara(5,3);pk5_4=pkpara(5,4);pk5_5=pkpara(5,5);
    pk5a=pk_names{5};
    pk6_1=pkpara(6,1);pk6_2=pkpara(6,2);pk6_3=pkpara(6,3);pk6_4=pkpara(6,4);pk6_5=pkpara(6,5);
    pk6a=pk_names{6};
    pk7_1=pkpara(7,1);pk7_2=pkpara(7,2);pk7_3=pkpara(7,3);pk7_4=pkpara(7,4);pk7_5=pkpara(7,5);
    pk7a=pk_names{7};
    pk8_1=pkpara(8,1);pk8_2=pkpara(8,2);pk8_3=pkpara(8,3);pk8_4=pkpara(8,4);pk8_5=pkpara(8,5);
    pk8a=pk_names{8};
    pk9_1=pkpara(9,1);pk9_2=pkpara(9,2);pk9_3=pkpara(9,3);pk9_4=pkpara(9,4);pk9_5=pkpara(9,5);
    pk9a=pk_names{9};
    pk10_1=pkpara(10,1);pk10_2=pkpara(10,2);pk10_3=pkpara(10,3);pk10_4=pkpara(10,4);pk10_5=pkpara(10,5);
    pk10a=pk_names{10};

    %set checkboxes default
    pk1c=pkc(1);
    pk2c=pkc(2);
    pk3c=pkc(3);
    pk4c=pkc(4);
    pk5c=pkc(5);
    pk6c=pkc(6);
    pk7c=pkc(7);
    pk8c=pkc(8);
    pk9c=pkc(9);
    pk10c=pkc(10);

    %markers dislplayed on plot
        %-Center of Gravity
    d1=marker(1);
        %-Peak local maxima
    d2=marker(2);
        %-Interpolated local maxima at assigned peak shift values
    d3=marker(3);


%% Pre-analysis
    raw_i=[x,y];

    %trim data
    if trim==1
        trim1=find(raw_i(:,1)<start_tm, 1 );
        raw_tm1=raw_i;
        raw_tm1(trim1:end,:)=[];
        trim2=find(raw_tm1(:,1)>end_tm, 1, 'last' );
        raw_tm2=raw_tm1;
        raw_tm2(1:trim2,:)=[];
    else
        raw_tm2=raw_i;
    end

    %background removal
        %-turn off warning
    id='MATLAB:polyfit:RepeatedPointsOrRescale';
    warning('off',id);
    if bg_rmv==0
        %-polyfitting
        p=polyfit(raw_tm2(:,1),raw_tm2(:,2),order_bk);
        %-Evaluate fit
        x=raw_tm2(:,1);
        y=polyval(p,x);
    else
        %-modified polyitting
        raw_mod=raw_tm2;
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
    y_bgr=raw_tm2(:,2)-y;   
    raman=[x,y_bgr];


%% Analysis

    %find peak values for band 1
    if pk1c==1
        try
            BandAnalysis(raman,pk1_1,pk1_2,pk1_4,pk1_5,pk1_3);
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

    %find peak values for band 3
    if pk2c==1
        try
            BandAnalysis(raman,pk2_1,pk2_2,pk2_4,pk2_5,pk2_3);
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
    else
        xpk2I=[];
        ypk2I=[];
        xpk2D=[];
        ypk2D=[];
        xpk2C=[];
        ypk2C=[];
        apk2=[];
    end

    %find peak value for band 3
    if pk3c==1
        try
            BandAnalysis(raman,pk3_1,pk3_2,pk3_4,pk3_5,pk3_3);
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

    %find peak values for band 4
    if pk4c==1
        try
            BandAnalysis(raman,pk4_1,pk4_2,pk4_4,pk4_5,pk4_3);
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
    else
        xpk4I=[];
        ypk4I=[];
        xpk4D=[];
        ypk4D=[];
        xpk4C=[];
        ypk4C=[];
        apk4=[];
    end

    %find peak value for band 5
    if pk5c==1
        try
            BandAnalysis(raman,pk5_1,pk5_2,pk5_4,pk5_5,pk5_3);
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

    %find peak value for band 6
    if pk6c==1
        try
            BandAnalysis(raman,pk6_1,pk6_2,pk6_4,pk6_5,pk6_3);
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

    %find peak value for band 7
    if pk7c==1
        try
            BandAnalysis(raman,pk7_1,pk7_2,pk7_4,pk7_5,pk7_3);
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

    %find peak value for band 8
    if pk8c==1
        try
            BandAnalysis(raman,pk8_1,pk8_2,pk8_4,pk8_5,pk8_3);
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

    %find peak values for band 9  
    if pk9c==1
        try
            BandAnalysis(raman,pk9_1,pk9_2,pk9_4,pk9_5,pk9_3);
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

    %find peak values for band 10  
    if pk10c==1
        try
            BandAnalysis(raman,pk10_1,pk10_2,pk10_4,pk10_5,pk10_3);
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

    %determine crystallinity
    if isequal(load_bio_para,'On')
        if pk1c==1
            try
                Crystallinity(raman);
                crystlnt=1/peakwidth;
            catch
                crystlnt=[];
            end
        else 
                crystlnt=[];
        end
    else
        crystlnt=[];
    end


%% Plot results

    %plot nomralized data
    figure('units','normalized','outerposition',[0 0 1 1]);
    plot(x,y_bgr,'Color','k');
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
            L2=scatter(xpk1D,ypk1D,'b','s','filled','DisplayName','band maxima');
        end
        if pk5c==1
            L2=scatter(xpk5D,ypk5D,'b','s','filled','DisplayName','band maxima');
        end
        if pk2c==1
            L2=scatter(xpk2D,ypk2D,'b','s','filled','DisplayName','band maxima');
        end
        if pk3c==1
            L2=scatter(xpk3D,ypk3D,'b','s','filled','DisplayName','band maxima');
        end
        if pk4c==1
            L2=scatter(xpk4D,ypk4D,'b','s','filled','DisplayName','band maxima');
        end
        if pk6c==1
            L2=scatter(xpk6D,ypk6D,'b','s','filled','DisplayName','band maxima');
        end
        if pk7c==1
            L2=scatter(xpk7D,ypk7D,'b','s','filled','DisplayName','band maxima');
        end
        if pk8c==1
            L2=scatter(xpk8D,ypk8D,'b','s','filled','DisplayName','band maxima');
        end
        if pk9c==1
            L2=scatter(xpk9D,ypk9D,'b','s','filled','DisplayName','band maxima');
        end
        if pk10c==1
            L2=scatter(xpk10D,ypk10D,'b','s','filled','DisplayName','band maxima');
        end
    else
        L2=[];
    end

    %plot local maxima at assigned peak wavenumbers
    if d3==1
        if pk1c==1
            L3=scatter(xpk1I,ypk1I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk5c==1
            L3=scatter(xpk5I,ypk5I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk2c==1
            L3=scatter(xpk2I,ypk2I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk3c==1
            L3=scatter(xpk3I,ypk3I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk4c==1
            L3=scatter(xpk4I,ypk4I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk6c==1
            L3=scatter(xpk6I,ypk6I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk7c==1
            L3=scatter(xpk7I,ypk7I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk8c==1
            L3=scatter(xpk8I,ypk8I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk9c==1
            L3=scatter(xpk9I,ypk9I,'m','s','filled','DisplayName','assigned peak');
        end
        if pk10c==1
            L3=scatter(xpk10I,ypk10I,'m','s','filled','DisplayName','assigned peak');
        end
    else
        L3=[];
    end
    
    %assign band names on plot
    space=max(raman(:,2))*0.05;
    if pk1c==1
        txt1=pk1a;
        text(xpk1D,ypk1D+space,txt1);
    end
    if pk5c==1
        txt2=pk5a;
        text(xpk5D,ypk5D+space,txt2);
    end
    if pk2c==1
        txt3=pk2a;
        text(xpk2D,ypk2D+space,txt3);
    end
    if pk3c==1
        txt4=pk3a;
        text(xpk3D,ypk3D+space,txt4);
    end
    if pk4c==1
        txt5=pk4a;
        text(xpk4D,ypk4D+space,txt5);
    end
    if pk6c==1
        txt6=pk6a;
        text(xpk6D,ypk6D+space,txt6);
    end
    if isequal(load_bio_para,'On')
        if pk6c==0
            if pk7c==1
                txt7=pk7a;
                text(xpk7D,ypk7D+space,txt7);
            end
            if pk8c==1
                txt8=pk8a;
                text(xpk8D,ypk8D+space,txt8);
            end
        end
    else
        if pk7c==1
            txt7=pk7a;
            text(xpk7D,ypk7D+space,txt7);
        end
        if pk8c==1
            txt8=pk8a;
            text(xpk8D,ypk8D+space,txt8);
        end
    end
    if pk9c==1
        txt9=pk9a;
        text(xpk9D,ypk9D+space,txt9);
    end
    if pk10c==1
        txt10=pk10a;
        text(xpk10D,ypk10D+space,txt10);
    end

    %show crystallinity in plot
    if pk1c==1
        L4=line([xwidth1 xwidth2],[halfheight halfheight],'LineStyle','-','Color','r','DisplayName','crystallinity');
    else
        L4=[];
    end

    try
        legend([L1 L2 L3 L4]);
    catch
    end


%% Prepare Results

    %arrange results into cells
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
    results=cell(14,numel(pkcid));
    for i=1:numel(pkcid)
        a=pkcid(i);
        results{1,i}=Peak(a);
        results{2,i}=Start_Shift(a);
        results{3,i}=End_Shift(a);
        results{4,i}=Peak_Shift(a);
        results{5,i}=Smoothing_Factor(a);
        results{6,i}=HWHM(a);
        results{7,i}=Area(a);
        results{8,i}=COG_x(a);
        results{9,i}=COG_y(a);
        results{10,i}=Maxima_drv_x(a);
        results{11,i}=Maxima_drv_y(a);
        results{12,i}=Maxima_interp_x(a);
        results{13,i}=Maxima_interp_y(a);
        results{14,i}=crystallinity(a);
    end

%pass restults to 'caller'
    assignin('caller','pkcid_i',pkcid);
    assignin('caller','pkcresults_i',results);
    
    
end

