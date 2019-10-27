function BandFWHM(input1,input2)

%define inputs
    input=[input1 input2];
    input_max=max(input);

%smooth 'M' using moving average method with a span of 30
    ysm=smooth(input2,30,'moving');
    xHrange=input1;
    Input=[xHrange,input2];
    Msmt=[xHrange,ysm];

%find min indices of 'Msmt'
    y_Msmt=Msmt(:,2);
    n1=ceil(size(y_Msmt)/2);
    n2=n1(:,1);
    y_Msmt_t1=y_Msmt(1:n2);
    y_Msmt_t2=y_Msmt(n1+1:end);
    [~,min_idx1]=min(y_Msmt_t1);
    [~,min_idx2]=min(y_Msmt_t2);

%get baseline equation
    x1=Msmt(min_idx1,1);
    y1=Msmt(min_idx1,2);
    x2=Msmt(min_idx2+n2,1);
    y2=Msmt(min_idx2+n2,2);
    A=[x1,1;x2,1];
    B=[y1;y2];
    X=linsolve(A,B);
    a=X(1,:);
    b=X(2,:);

%generate matrix for removing baseline
    x=Msmt(:,1);
    background=a*x+b;
    y_new=y_Msmt-background;

%check if background removal succesful
    if min(y_new)<-1
        check=0;
    else
        check=1;
    end

    if check==0
        [~,pk_loc]=max(Input(:,2));
        x_2theta=xHrange(pk_loc,1);
    else
%remove background
        M_new=[Msmt(:,1),y_new];

%trim new data
        curve_start=find(y_new<0.1,1);    
        if curve_start>1
            y_new(1:curve_start-1,:)=[];
            M_new(1:curve_start-1,:)=[];
        end
        curve_end=find(y_new<0.1,1,'last');
        [M_new_col,~]=size(M_new);
        if M_new_col>curve_end
            y_new(curve_end+1:end,:)=[];
            M_new(curve_end+1:end,:)=[];
        end

%find max y value in M_new
        max_M_new=max(M_new(:,2));

%find half value and interpret relative indices
        y_hmax=max_M_new/2;
        hf_idx1=find(M_new(:,2)>y_hmax,1) +[-1 0];
        if hf_idx1(1,1)==0
            hf_idx1=hf_idx1+1;
        end
        hf_idx2=find(M_new(:,2)>y_hmax,1,'last') +[0 1];
        if hf_idx2(1,1)==numel(y_new)
            hf_idx2=hf_idx2-1;
        end
        x_new=M_new(:,1);
        try
            x_hf1=interp1(y_new(hf_idx1),x_new(hf_idx1),y_hmax);
            x_hf2=interp1(y_new(hf_idx2),x_new(hf_idx2),y_hmax);
        catch
            x_hf1=input_max(1,1);
            x_hf2=x_hf1;
        end

%find theta value
        x_2theta=x_hf1+(x_hf2-x_hf1)/2;
    end

% Send results to Workplace.
    assignin('caller','theta',x_2theta);
end



