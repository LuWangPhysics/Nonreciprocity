function [M,Rot]=layers_all_calculate(Rot,C,theta_arr_n,rotate_n,d,N_of_slab)

                        kx=Rot.n1*C.k0*sin(theta_arr_n);
                        ky=0;

                        %get the rotation matrix for the in and out layer
                        Rot=Rot.Rot_sp_To_xyz(theta_arr_n,C);  
                        M=eye(4,4);
                        for n_k=2:C.number_of_interface
                            meps=material_select(n_k,C,rotate_n,N_of_slab);
                            M_layer=M_matrix(meps,kx,ky,C,d(n_k-1));
                            M=M_layer*M;
            
                        end
end