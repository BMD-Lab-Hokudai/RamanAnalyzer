function DefaultsGeneral()

%calibration
    %-calibrate before each run? '1'=YES, '0'=NO
    cal=1; %if cal=0, run seperate manual calibration file and entre value below.
    auto_cal=1;
    wavenumber_ref = 520.5;
    wavenumber_input = 524.7452;

%trimming
    trim=0; %'1'=apply trim, '0'=NOT apply trim
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
    %-band 1
    pk1_1=0;pk1_2=0;pk1_3=0;pk1_4=0;pk1_5=0;pk1_6=0;pk1_7=0;
    pk1=[pk1_1 pk1_2 pk1_3 pk1_4 pk1_5 pk1_6 pk1_7];
    pk1a='';
    %-band 2
    pk2_1=0;pk2_2=0;pk2_3=0;pk2_4=0;pk2_5=0;pk2_6=0;pk2_7=0;
    pk2=[pk2_1 pk2_2 pk2_3 pk2_4 pk2_5 pk2_6 pk2_7];
    pk2a='';
    %-band 3
    pk3_1=0;pk3_2=0;pk3_3=0;pk3_4=0;pk3_5=0;pk3_6=0;pk3_7=0;
    pk3=[pk3_1 pk3_2 pk3_3 pk3_4 pk3_5 pk3_6 pk3_7];
    pk3a='';
    %-band 4
    pk4_1=0;pk4_2=0;pk4_3=0;pk4_4=0;pk4_5=0;pk4_6=0;pk4_7=0;
    pk4=[pk4_1 pk4_2 pk4_3 pk4_4 pk4_5 pk4_6 pk4_7];
    pk4a='';
    %-band 5
    pk5_1=0;pk5_2=0;pk5_3=0;pk5_4=0;pk5_5=0;pk5_6=0;pk5_7=0;
    pk5=[pk5_1 pk5_2 pk5_3 pk5_4 pk5_5 pk5_6 pk5_7];
    pk5a='';
    %-band 6
    pk6_1=0;pk6_2=0;pk6_3=0;pk6_4=0;pk6_5=0;pk6_6=0;pk6_7=0;
    pk6=[pk6_1 pk6_2 pk6_3 pk6_4 pk6_5 pk6_6 pk6_7];
    pk6a='';
    %-band 7
    pk7_1=0;pk7_2=0;pk7_3=0;pk7_4=0;pk7_5=0;pk7_6=0;pk7_7=0;
    pk7=[pk7_1 pk7_2 pk7_3 pk7_4 pk7_5 pk7_6 pk7_7];
    pk7a='';
    %-band 8
    pk8_1=0;pk8_2=0;pk8_3=0;pk8_4=0;pk8_5=0;pk8_6=0;pk8_7=0;
    pk8=[pk8_1 pk8_2 pk8_3 pk8_4 pk8_5 pk8_6 pk8_7];
    pk8a='';
    %-band 9
    pk9_1=0;pk9_2=0;pk9_3=0;pk9_4=0;pk9_5=0;pk9_6=0;pk9_7=0;
    pk9=[pk9_1 pk9_2 pk9_3 pk9_4 pk9_5 pk9_6 pk9_7];
    pk9a='';
    %-band 10
    pk10_1=0;pk10_2=0;pk10_3=0;pk10_4=0;pk10_5=0;pk10_6=0;pk10_7=0;
    pk10=[pk10_1 pk10_2 pk10_3 pk10_4 pk10_5 pk10_6 pk10_7];
    pk10a='';

%set checkboxes default
    pk1c=0;
    pk2c=0;
    pk3c=0;
    pk4c=0;
    pk5c=0;
    pk6c=0;
    pk7c=0;
    pk8c=0;
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
    run_curve_fit=1; %'1'=YES; '0'=NO
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
    pkana=0; % '1'=YES; '0'=NO

%pass results to 'caller'
    assignin('caller','cal',cal);
    assignin('caller','auto_cal',auto_cal);
    assignin('caller','wavenumber_ref',wavenumber_ref);
    assignin('caller','wavenumber_input',wavenumber_input);
    assignin('caller','trim',trim);
    assignin('caller','start_tm',start_tm);
    assignin('caller','end_tm',end_tm);
    assignin('caller','order_smt',order_smt);
    assignin('caller','size_smt',size_smt);
    assignin('caller','bg_rmv',bg_rmv);
    assignin('caller','order_bk',order_bk);
    assignin('caller','norm_type',norm_type);
    assignin('caller','pk1_1',pk1_1);
    assignin('caller','pk1_2',pk1_2);
    assignin('caller','pk1_3',pk1_3);
    assignin('caller','pk1_4',pk1_4);
    assignin('caller','pk1_5',pk1_5);
    assignin('caller','pk1_6',pk1_6);
    assignin('caller','pk1_7',pk1_7);
    assignin('caller','pk1',pk1);
    assignin('caller','pk1a',pk1a);
    assignin('caller','pk2_1',pk2_1);
    assignin('caller','pk2_2',pk2_2);
    assignin('caller','pk2_3',pk2_3);
    assignin('caller','pk2_4',pk2_4);
    assignin('caller','pk2_5',pk2_5);
    assignin('caller','pk2_6',pk2_6);
    assignin('caller','pk2_7',pk2_7);
    assignin('caller','pk2',pk2);
    assignin('caller','pk2a',pk2a);
    assignin('caller','pk3_1',pk3_1);
    assignin('caller','pk3_2',pk3_2);
    assignin('caller','pk3_3',pk3_3);
    assignin('caller','pk3_4',pk3_4);
    assignin('caller','pk3_5',pk3_5);
    assignin('caller','pk3_6',pk3_6);
    assignin('caller','pk3_7',pk3_7);
    assignin('caller','pk3',pk3);
    assignin('caller','pk3a',pk3a);
    assignin('caller','pk4_1',pk4_1);
    assignin('caller','pk4_2',pk4_2);
    assignin('caller','pk4_3',pk4_3);
    assignin('caller','pk4_4',pk4_4);
    assignin('caller','pk4_5',pk4_5);
    assignin('caller','pk4_6',pk4_6);
    assignin('caller','pk4_7',pk4_7);
    assignin('caller','pk4',pk4);
    assignin('caller','pk4a',pk4a);
    assignin('caller','pk5_1',pk5_1);
    assignin('caller','pk5_2',pk5_2);
    assignin('caller','pk5_3',pk5_3);
    assignin('caller','pk5_4',pk5_4);
    assignin('caller','pk5_5',pk5_5);
    assignin('caller','pk5_6',pk5_6);
    assignin('caller','pk5_7',pk5_7);
    assignin('caller','pk5',pk5);
    assignin('caller','pk5a',pk5a);
    assignin('caller','pk6_1',pk6_1);
    assignin('caller','pk6_2',pk6_2);
    assignin('caller','pk6_3',pk6_3);
    assignin('caller','pk6_4',pk6_4);
    assignin('caller','pk6_5',pk6_5);
    assignin('caller','pk6_6',pk6_6);
    assignin('caller','pk6_7',pk6_7);
    assignin('caller','pk6',pk6);
    assignin('caller','pk6a',pk6a);
    assignin('caller','pk7_1',pk7_1);
    assignin('caller','pk7_2',pk7_2);
    assignin('caller','pk7_3',pk7_3);
    assignin('caller','pk7_4',pk7_4);
    assignin('caller','pk7_5',pk7_5);
    assignin('caller','pk7_6',pk7_6);
    assignin('caller','pk7_7',pk7_7);
    assignin('caller','pk7',pk7);
    assignin('caller','pk7a',pk7a);
    assignin('caller','pk8_1',pk8_1);
    assignin('caller','pk8_2',pk8_2);
    assignin('caller','pk8_3',pk8_3);
    assignin('caller','pk8_4',pk8_4);
    assignin('caller','pk8_5',pk8_5);
    assignin('caller','pk8_6',pk8_6);
    assignin('caller','pk8_7',pk8_7);
    assignin('caller','pk8',pk8);
    assignin('caller','pk8a',pk8a);
    assignin('caller','pk9_1',pk9_1);
    assignin('caller','pk9_2',pk9_2);
    assignin('caller','pk9_3',pk9_3);
    assignin('caller','pk9_4',pk9_4);
    assignin('caller','pk9_5',pk9_5);
    assignin('caller','pk9_6',pk9_6);
    assignin('caller','pk9_7',pk9_7);
    assignin('caller','pk9',pk9);
    assignin('caller','pk9a',pk9a);
    assignin('caller','pk10_1',pk10_1);
    assignin('caller','pk10_2',pk10_2);
    assignin('caller','pk10_3',pk10_3);
    assignin('caller','pk10_4',pk10_4);
    assignin('caller','pk10_5',pk10_5);
    assignin('caller','pk10_6',pk10_6);
    assignin('caller','pk10_7',pk10_7);
    assignin('caller','pk10',pk10);
    assignin('caller','pk10a',pk10a);
    assignin('caller','d1',d1);
    assignin('caller','d2',d2);
    assignin('caller','d3',d3);
    assignin('caller','d4',d4);
    assignin('caller','override',override);
    assignin('caller','type',type);
    assignin('caller','run_curve_fit',run_curve_fit);
    assignin('caller','remove_background',remove_background);
    assignin('caller','fix_location',fix_location);
    assignin('caller','type_locs',type_locs);
    assignin('caller','fun_type',fun_type);
    assignin('caller','frac',frac);
    assignin('caller','algo',algo);
    assignin('caller','pkana',pkana);
    assignin('caller','pk1c',pk1c);
    assignin('caller','pk2c',pk2c);
    assignin('caller','pk3c',pk3c);
    assignin('caller','pk4c',pk4c);
    assignin('caller','pk5c',pk5c);
    assignin('caller','pk6c',pk6c);
    assignin('caller','pk7c',pk7c);
    assignin('caller','pk8c',pk8c);
    assignin('caller','pk9c',pk9c);
    assignin('caller','pk10c',pk10c);
end
        