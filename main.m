clear all;
addpath('my_struct');
addpath('my_function');
addpath('my_plot_scheme');

P=my_plot;
lambda0=10e-6;
%---------------------------------------------------------
%choose reflection or transmission geometry "R" or "T"
%---------------------------------------------------------
geometry_config="R";
C=cons(lambda0,geometry_config);  
Rot=Rot_two_medium;
Rot=Rot.init(geometry_config);
%---------------------------------------------------------
%define incidence angle array
%--------------------------------------------------------
theta_margin=0.1*pi/180;
theta_arr=linspace(0+theta_margin,pi/2-theta_margin,82);
        
%---------------------------------------------------------
%data store 
%---------------------------------------------------------
delta_ignore=1e-6;
D=Data_storage;
D=D.init(delta_ignore,theta_arr);

tic
%---------------------------------------------------------
%define plot scan variables
%---------------------------------------------------------
D=D.variable(1,1,theta_arr);
%---------------------------------------------------------
%define thickness of each material d_arr=[material 1, material 2.....]
%change these 3 parameters consistently
%---------------------------------------------------------
d_arr=([1e-6,3.2e-6]);
N_of_slab=length(d_arr);
C.number_of_interface=1+N_of_slab;
%---------------------------------------------------------
%define saving string
%---------------------------------------------------------
filename=['my_output/test_d1' num2str(d_arr(1),'%2.2f')];
if ~exist(filename, 'dir')
       mkdir(filename);
end

    
        for rotate_n=1:1:C.Rotation_iter
                %for incidenting from below, the thickness follow reverse
                %order 
                if rotate_n>2
                    d=flip(d_arr);
                else
                    d=d_arr;
                end

                for theta_n=1:length(theta_arr)     
                     [M,Rot]=layers_all_calculate(Rot,C,theta_arr(theta_n),rotate_n,d,N_of_slab);
                             
                     ref_c=r_s_process(M,Rot,delta_ignore);  
                     D=D.assign(ref_c,theta_n,rotate_n);
                     D=D.manipulate_angle(1,theta_n,ref_c);               
                end
        end
        D=D.eta;
        D=D.manipulate_d(1,1,theta_arr,ref_c);
          


%---------------------------------------------------------
%plots
%---------------------------------------------------------
P.angle_scan(theta_arr,D.mat,filename);
P.a_e(theta_arr,D,filename);

