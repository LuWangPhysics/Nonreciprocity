function [meps]=material_select(number,C,rotate_n,N_of_slab)

if rotate_n<3
    %the upper half space the 
slab_ID=number-1;
else
   %lower half space the material order is inversed

slab_ID=2+N_of_slab-number;
end

phi_1=0;
phi_2=0;
phi_3=0;
        %numbers represent incidence Quadrant
        %2 rotate about z axis 180 degree to get the -kx part (theta negative part)
        %3 rotate about x to get the incidence from below part
        %4 rotate about x and z to get below -kx
switch rotate_n
   case 2
       %rotate about z axies to get the -kx part
      phi_1=phi_1+pi;
   case 3
       %rotate about x axis to get theta_below
      phi_2=phi_2+pi;
   case 4
       %rotate about x and z to get theta_below -kx
      phi_2=phi_2+pi;
      phi_3=phi_3+pi;

end

%--------------------------------------
%rotate about z axis
%--------------------------------------
euler_z=[cos(phi_1),sin(phi_1),0;...
        -sin(phi_1),cos(phi_1),0;...
        0,0,1];
%--------------------------------------
%rotate about x' axis, the the new x,after first rotate
%--------------------------------------
euler_xp=[1,0,0;...
     0,cos(phi_2),sin(phi_2);...
      0, -sin(phi_2),cos(phi_2)];
%--------------------------------------
%rotate about z'' axis, the new z after twice rotate
%--------------------------------------
euler_zpp=[cos(phi_3),sin(phi_3),0;...
        -sin(phi_3),cos(phi_3),0;...
        0,0,1];

euler_R=euler_zpp*euler_xp*euler_z;

switch slab_ID
    case 1

       dia=9+0.3*1i;
       off_dia=12*1i;
       meps=C.eps0.*[dia,0,off_dia;...
                    0,  dia,  0; ...
                  -off_dia,0, dia];  

    
        meps=euler_R*meps/(euler_R);

     case 2
         n_die=1.5;
        meps=C.eps0.*[n_die,0,0;...
             0,n_die,0;...
            0,0,n_die].^2;

        meps=euler_R*meps/(euler_R);

% if there is a third layer add 
%case 3
%....

    otherwise
        fprintf("no material defined. make sure layer agrees with material number")
end



end