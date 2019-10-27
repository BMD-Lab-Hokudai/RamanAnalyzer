function CurveFit(name,raw,settings,pk_names,pk_para)

%% Parameters

    %1.apply linear back ground removal? '0'=NO; '1'=YES
    remove_background=settings(1);

    %2.do you want to fix sub-curves' peak loacation? '1'=YES; '0'=NO
    fix_location=settings(2);
    %-if peak locations are fixed (fix_location=1), do you want to enter peak locations using keyboard?
    type_locs=settings(3); %'0'=automatically get locs from mouse clicks; '1'=manually enter locs via keyboard

    %3.which fitting function do you want to use? 
    fun_type=settings(4); %'0'=Gaussian; '1'=Lorentzian; '2'=Gauss-Lorenz Mix (G-L)
    p=settings(5); %if using G-L, enter GAUSSIAN fracton here

    %4.which fitting algorithm do you want to use? '0'=Trust-Region-Reflective
    %(matlab default); '1'=Levenberg-Marquardt
    algo=settings(6);


%% Getting starting conditions

    % x=linspace(min(raw(:,1)),max(raw(:,1)));
    x=min(raw(:,1)):0.5:max(raw(:,1));
    
    %apply linear background removal    
    if remove_background==1
        [~,id]=max(raw(:,2));
        [miny1,minxid1]=min(raw(1:id,2));
        [miny2,minxid2]=min(raw(id:end,2));
        minx1=raw(minxid1,1);
        minx2=raw(minxid2+id-1,1);   
        coeff=polyfit([minx1,minx2],[miny1,miny2],1);
        al=coeff(1);
        bl=coeff(2);
        linebkg=@(x) al*x+bl;
        bkgrnd=linebkg(raw(:,1));
        raw=[raw(:,1),raw(:,2)-bkgrnd];
    end

    %determine band name  
    avg_raw=mean(raw(:,1));
    avg_para=zeros(1,10);
    for i=1:10
        avg_para(i)=pk_para(i,3);
    end
    [~,id]=min(abs(avg_para-avg_raw));
    pk_name=pk_names{id};
    
    %plot raw
    szcheck=1;
    while szcheck~=0    
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        plot(raw(:,1),raw(:,2));
        minaxis=roundn((min(raw(:,1))-50),2);
        maxaxis=roundn((max(raw(:,1))+50),2);
        maxintn=(max(raw(:,2)))*1.2;
        axis([minaxis maxaxis 0 maxintn]);
        xlabel('Raman shift (cm^{-1})')
        ylabel('Intensity (normalized)')
        title({['Sample ' name(1) ' (' pk_name(1) ') Band - Start Condition'];'A Sub-Curve is Defined by THREE Mouse-Clicks in the Following Order:';'[Aprrox. Mid-Point of the Left(Right) Slope] - [Approx. Peak Point] - [Aprrox. Mid-Point of the Right(Left) Slope]';'PRESS "ENTER" AFTER FINISH TO START CURVE FITTING.'});
        hold on     
        curve_fit_input=0;
        locs=zeros(100,1);
        intn=zeros(100,1);
        colors={'g','r','k'};
        n=0;
        intn_check=0;
        intn_checki=zeros(1,3);
        locs_check=zeros(1,2);
        while curve_fit_input==0
            n=n+1;
            try
            [locsi,intni]=ginput(1);
            locs(n)=locsi;
            intn(n)=intni;
            if rem(n,3)==1
                slope_point1=scatter(locsi,intni,colors{1},'*','LineWidth',1);
                intn_checki(1)=intni;
                locs_check(1)=locsi;
            elseif rem(n,3)==2
                scatter(locsi,intni,colors{2},'filled');
                intn_checki(2)=intni;
                if intn_checki(2)<=intn_checki(1)                   
                   locs=[];
                   intn_check=1;
                   i=msgbox('The Defined Peak Point Appears to be Lower Than the Slop Mid-Point. Please Try Again.','Warning','warn');
                   waitfor(i); 
                   break             
                end
            else
                intn_checki(3)=intni;
                locs_check(2)=locsi;
                if locs_check(2)>locs_check(1)
                    scatter(locsi,intni,colors{3},'+','LineWidth',1);
                else
                    delete(slope_point1);
                    scatter(locs_check(2),intn_checki(3),colors{1},'*','LineWidth',1);
                    scatter(locs_check(1),intn_checki(1),colors{3},'+','LineWidth',1);
                    locs([n-2 n])=locs([n n-2]);
                end         
                if intn_checki(2)<=intn_checki(3)                   
                   locs=[];
                   intn_check=1;
                   i=msgbox('The Defined Peak Point Appears to be Lower Than the Slop Mid-Point. Please Try Again.','Warning','warn');
                   waitfor(i); 
                   break             
                end
            end
            catch
                break
            end
        end
        locs(find(locs==0,1):end)=[];
        intn(find(intn==0,1):end)=[];
        szcheck=rem(numel(locs),3);
        if szcheck~=0
            i=msgbox({'Misclick May Have Occurred While Inputing the Start Condition. The Total Number of Points is NOT a Multiple of 3';[];'Please Try Again.'},'Warning','warn');
            waitfor(i);
            close(f);
        end
        if intn_check~=0
            szcheck=1;
            close(f);
        end
    end
    if type_locs==0
    wait=waitbar(0,'Generating Start Condition...','Name','Please Wait');
    end
    n=numel(locs)/3;
    locs=reshape(locs,[3,n]);
    intn=reshape(intn,[3,n]);
    id='MATLAB:fplot:NotVectorized';
    warning('off',id);
    if fun_type==0
        d1=strings(1,6);
    elseif fun_type==1
        d1=strings(1,8);
    else
        d1=strings(1,14);
    end

    %fit with fixed subpeak loacation (2 variables:FWHM,Max Intensity)
    if fix_location==1
        a0=[];
        b0=[];
        if type_locs==1
            input_peaks=1;
            while input_peaks==1
                input_peaks=0;
                answer = inputdlg('Enter Space-Separated Peak Locations:','Peak Locations', [1 50]);
                wait=waitbar(0,'Generating Start Condition...','Name','Please Wait');
                if numel(answer)==0 || isempty(answer{1})
                    input_peaks=1;
                else
                    answer=split(answer,{', ',',',' '});
                    b0=str2double(answer)';
                    if max(isnan(b0))==1 || min(b0)<1 || numel(b0)~=n || max(rem(b0,1)~=0)==1
                        errmsg1=msgbox({'Invalid Entry';[];'Please try again.'},'Warning','warn');
                        waitfor(errmsg1); 
                        input_peaks=1;
                    end 
                end             
            end           
        end
        for i=1:n
            ai=[intn(2,i),(locs(3,i)-locs(1,i))/2];
            if type_locs==0
                bi=locs(2,i);
            else
                bi=b0(i);
            end
            if fun_type==0
                yi=@(x) ai(1)*exp(-0.5*((x-bi)/ai(2))^2);
            elseif fun_type==1
                yi=@(x) ai(1)*((ai(2)^2)/(((x-bi)^2)+(ai(2)^2)));
            else
                yi=@(x) p*(ai(1)*exp(-0.5*((x-bi)/ai(2))^2))+(1-p)*(ai(1)*((ai(2)^2)/(((x-bi)^2)+(ai(2)^2))));
            end
            fplot(yi,'Linestyle','-');
            a0=cat(2,a0,ai);
            b0=cat(2,b0,bi);
        end
            %-generate initial curve equation
        at1="@(x)";
        funstr0i=strings(1,n+1);
        funstr0i(1)=at1;
        for i=1:n
            if fun_type==0
                fun0i=["a0(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/a0(",num2str(2*i),")).^2)"];
            elseif fun_type==1
                fun0i=["a0(",num2str(2*i-1),")*((a0(",num2str(2*i),").^2)/(((x-b0(",num2str(i),")).^2)+(a0(",num2str(2*i),").^2)))"];
            else
                fun0i=["p*(a0(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/a0(",num2str(2*i),")).^2))+(1-p)*(a0(",num2str(2*i-1),")*((a0(",num2str(2*i),").^2)/(((x-b0(",num2str(i),")).^2)+(a0(",num2str(2*i),").^2))))"];
            end
            fun0ij=join(fun0i,d1);
            funstr0i(i+1)=fun0ij;
        end
        d2=strings(1,n);
        for i=2:n
            d2(i)="+";
        end
        funstr0=join(funstr0i,d2);
        fun0=eval(funstr0);
        fplot(fun0,'k','Linestyle','--');
        data=csaps(raw(:,1),raw(:,2),1); %#ok<NASGU> the variable 'data' is used in line 214
        mdl = fitlm(raw(:,1),raw(:,2));
        rsd=mdl.Residuals.Raw;
        rsd=csaps(raw(:,1),rsd(:,1),1); %#ok<NASGU> the variable 'rsd' is used in line 215
            %-generate equation for curve fitting: residual of fitted curve-residual of
            %-data
        at2="@(a)";
        datastr="(ppval(data,x)-(";
        rsdstr="))-ppval(rsd,raw(:,1))";
        funstri=strings(1,n+3);
        funstri(1)=at2;funstri(2)=datastr;funstri(n+3)=rsdstr;
        for i=1:n
            if fun_type==0
                funi=["a(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/a(",num2str(2*i),")).^2)"];
            elseif fun_type==1
                funi=["a(",num2str(2*i-1),")*((a(",num2str(2*i),").^2)./(((x-b0(",num2str(i),")).^2)+(a(",num2str(2*i),").^2)))"];
            else
                funi=["p*(a(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/a(",num2str(2*i),")).^2))+(1-p)*(a(",num2str(2*i-1),")*((a(",num2str(2*i),").^2)./(((x-b0(",num2str(i),")).^2)+(a(",num2str(2*i),").^2))))"];  
            end
            funij=join(funi,d1);
            funstri(i+2)=funij;
        end
        d3=strings(1,n+2);
        for i=3:n+1
            d3(i)="+";
        end
        funstr=join(funstri,d3);
        fun=eval(funstr);
    else
    %fit with free moving subpeak loacation (3 variables)
        a0=[];
        for i=1:n
            ai=[intn(2,i),locs(2,i),(locs(3,i)-locs(1,i))/2];
            if fun_type==0
            yi=@(x) ai(1)*exp(-0.5*((x-ai(2))/ai(3))^2);
            elseif fun_type==1
            yi=@(x) ai(1)*((ai(3)^2)/(((x-ai(2))^2)+(ai(3)^2)));
            else
            yi=@(x) p*(ai(1)*exp(-0.5*((x-ai(2))/ai(3))^2))+(1-p)*(ai(1)*((ai(3)^2)/(((x-ai(2))^2)+(ai(3)^2))));
            end
            fplot(yi,'Linestyle','-');
            a0=cat(2,a0,ai);
        end
        %-generate initial curve equation
        at1="@(x)";
        funstr0i=strings(1,n+1);
        funstr0i(1)=at1;
        for i=1:n
            if fun_type==0
                fun0i=["a0(",num2str(3*i-2),")*exp(-0.5*((x-a0(",num2str(3*i-1),"))/a0(",num2str(3*i),")).^2)"];
            elseif fun_type==1
                fun0i=["a0(",num2str(3*i-2),")*((a0(",num2str(3*i),").^2)/(((x-a0(",num2str(3*i-1),")).^2)+(a0(",num2str(3*i),").^2)))"];
            else
                fun0i=["p*(a0(",num2str(3*i-2),")*exp(-0.5*((x-a0(",num2str(3*i-1),"))/a0(",num2str(3*i),")).^2))+(1-p)*(a0(",num2str(3*i-2),")*((a0(",num2str(3*i),").^2)/(((x-a0(",num2str(3*i-1),")).^2)+(a0(",num2str(3*i),").^2))))"];
            end
            fun0ij=join(fun0i,d1);
            funstr0i(i+1)=fun0ij;
        end
        d2=strings(1,n);
        for i=2:n
            d2(i)="+";
        end
        funstr0=join(funstr0i,d2);
        fun0=eval(funstr0);
        fplot(fun0,'k','Linestyle','--');
        data=csaps(raw(:,1),raw(:,2),1); %#ok<NASGU> the variable 'data' is used in line 277
        mdl = fitlm(raw(:,1),raw(:,2));
        rsd=mdl.Residuals.Raw;
        rsd=csaps(raw(:,1),rsd(:,1),1); %#ok<NASGU> the variable 'data' is used in line 278
        at2="@(a)";
        datastr="(ppval(data,x)-(";
        rsdstr="))-ppval(rsd,raw(:,1))";
        funstri=strings(1,n+3);
        funstri(1)=at2;funstri(2)=datastr;funstri(n+3)=rsdstr;
        for i=1:n
            if fun_type==0
                funi=["a(",num2str(3*i-2),")*exp(-0.5*((x-a(",num2str(3*i-1),"))/a(",num2str(3*i),")).^2)"];
            elseif fun_type==1
                funi=["a(",num2str(3*i-2),")*((a(",num2str(3*i),").^2)./(((x-a(",num2str(3*i-1),")).^2)+(a(",num2str(3*i),").^2)))"];
            else
                funi=["p*(a(",num2str(3*i-2),")*exp(-0.5*((x-a(",num2str(3*i-1),"))/a(",num2str(3*i),")).^2))+(1-p)*(a(",num2str(3*i-2),")*((a(",num2str(3*i),").^2)./(((x-a(",num2str(3*i-1),")).^2)+(a(",num2str(3*i),").^2))))"];
            end
            funij=join(funi,d1);
            funstri(i+2)=funij;
        end
        d3=strings(1,n+2);
        for i=3:n+1
            d3(i)="+";
        end
        funstr=join(funstri,d3);
        fun=eval(funstr);
    end


%% Apply curve fitting

    %generate sub curves
    waitbar(.5,wait,'Performing Curve Fitting...','Name','Please Wait');
    options.MaxFunctionEvaluations = 10000;
    options.StepTolerance=1e-10;
    options.FunctionTolerance=1e-10;
    options.Display='off';
    if algo==1
        options.Algorithm = 'levenberg-marquardt';
        [b,resnorm,residual,~,~,~,~]=lsqnonlin(fun,a0,[],[],options);
    else
        lb=zeros(1,numel(a0));
        [b,resnorm,residual,~,~,~,~]=lsqnonlin(fun,a0,lb,[],options);
    end
    residualavg=mean(residual);
    waitbar(1,wait,'Complete.','Name','Curve Fitting Complete');
    pause(0.5);
    delete(wait);

    %plot fitted sub-curves
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    %plot residual
    F_2=subplot(2,1,2);
    set(F_2,'OuterPosition',[0,0.06,1,0.2]);
    line([minaxis maxaxis],[0 0],'color','k','Linestyle','--');
    hold on
    plot(x,residualavg,'k');
    axis([minaxis maxaxis -1.5*max(abs(residualavg)) 1.5*max(abs(residualavg))]);
    xlabel('Raman shift (cm^{-1})')
    title('Residual');
    F_1=subplot(2,1,1);
    set(F_1,'OuterPosition',[0,0.27,1,0.75]);
    plot(raw(:,1),raw(:,2));
    minaxis=roundn((min(raw(:,1))-50),2);
    maxaxis=roundn((max(raw(:,1))+50),2);
    maxintn=(max(raw(:,2)))*1.2;
    axis([minaxis maxaxis 0 maxintn]);
    xlabel('Raman shift (cm^{-1})')
    ylabel('Intensity (normalized)')
    title(['Sample ' name ' (' pk_name ') Band - Final Fit']);
    hold on
    if fix_location==1
        for i=1:n
            if fun_type==0
                yi=@(x) b(2*i-1)*exp(-0.5*((x-b0(i))/b(2*i))^2);
            elseif fun_type==1
                yi=@(x) b(2*i-1)*((b(2*i)^2)/(((x-b0(i))^2)+(b(2*i)^2)));
            else
                yi=@(x) p*(b(2*i-1)*exp(-0.5*((x-b0(i))/b(2*i))^2))+(1-p)*(b(2*i-1)*((b(2*i)^2)/(((x-b0(i))^2)+(b(2*i)^2))));
            end
            fplot(yi,'Linestyle','-');
        end
    else
        for i=1:n
            if fun_type==0
                yi=@(x) b(3*i-2)*exp(-0.5*((x-b(3*i-1))/b(3*i))^2);
            elseif fun_type==1
                yi=@(x) b(3*i-2)*((b(3*i)^2)/(((x-b(3*i-1))^2)+(b(3*i)^2)));
            else
                yi=@(x) p*(b(3*i-2)*exp(-0.5*((x-b(3*i-1))/b(3*i))^2))+(1-p)*(b(3*i-2)*((b(3*i)^2)/(((x-b(3*i-1))^2)+(b(3*i)^2))));
            end
            fplot(yi,'Linestyle','-');
        end
    end

    %generate fitted curve equation
    funstrfi=strings(1,n+1);
    funstrfi(1)=at1;
    if fix_location==1
        for i=1:n
            if fun_type==0
                funfi=["b(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/b(",num2str(2*i),")).^2)"];
            elseif fun_type==1
                funfi=["b(",num2str(2*i-1),")*((b(",num2str(2*i),").^2)./(((x-b0(",num2str(i),")).^2)+(b(",num2str(2*i),").^2)))"];
            else
                funfi=["p*(b(",num2str(2*i-1),")*exp(-0.5*((x-b0(",num2str(i),"))/b(",num2str(2*i),")).^2))+(1-p)*(b(",num2str(2*i-1),")*((b(",num2str(2*i),").^2)./(((x-b0(",num2str(i),")).^2)+(b(",num2str(2*i),").^2))))"];
            end
            funf=join(funfi,d1);
            funstrfi(i+1)=funf;
        end
    else
        for i=1:n
            if fun_type==0
                funfi=["b(",num2str(3*i-2),")*exp(-0.5*((x-b(",num2str(3*i-1),"))/b(",num2str(3*i),")).^2)"];
            elseif fun_type==1
                funfi=["b(",num2str(3*i-2),")*((b(",num2str(3*i),").^2)./(((x-b(",num2str(3*i-1),")).^2)+(b(",num2str(3*i),").^2)))"];
            else
                funfi=["p*(b(",num2str(3*i-2),")*exp(-0.5*((x-b(",num2str(3*i-1),"))/b(",num2str(3*i),")).^2))+(1-p)*(b(",num2str(3*i-2),")*((b(",num2str(3*i),").^2)./(((x-b(",num2str(3*i-1),")).^2)+(b(",num2str(3*i),").^2))))"];
            end
            funf=join(funfi,d1);
            funstrfi(i+1)=funf;
        end
    end
    for i=2:n
        d2(i)="+";
    end
    funstrf=join(funstrfi,d2);
    funfit=eval(funstrf);
    fplot(funfit,'r','Linestyle','--');

    %finalize results and pass to 'caller'
    if fix_location==1
        b_odd=b(1:2:end);
        b_even=b(2:2:end);
        b=zeros(1,3*n);
        for i=1:n
            b(3*i-2)=b_odd(i);
            b(3*i-1)=b0(i);
            b(3*i)=b_even(i);
        end
    end
    residual=[x',residualavg'];
    assignin('caller','b',b);
    assignin('caller','resnorm',resnorm);
    assignin('caller','peaknamecf',pk_name);
    assignin('caller','residual',residual);
end