classdef Data_storage
    properties
     delta_ignore;
     theta_select;
     mat;
     matb;
     eta_s;
     eta_p;
     angle_select;
     data_R;
     data_eta;
     data_a;
     N_single;
     angle_scan_flag;
     a_s;
     a_p;
     e_s;
     e_p;

    end

    methods 
        function obj=init(obj,delta_ignore,theta_half_arr)
                    length_data=2*length(theta_half_arr);
                    obj.N_single=length_data/2;
                    obj.delta_ignore=delta_ignore;
                    %mat is for angle array storage
                    obj.mat=zeros(8,length_data);
                    obj.matb=zeros(8,length_data);
                            
                    obj.eta_s=zeros(length_data,1);
                    obj.eta_p=zeros(length_data,1);
        end
        


        function obj=variable(obj,d_scan1,d_scan2,theta_arr)
            d_theta=theta_arr(2)-theta_arr(1);
            %select if there is a specific angle of interest
            obj.theta_select=fix((0:2:90)*pi/180/d_theta)+1;
            if length(d_scan2)>1
              obj.data_eta=zeros(length(obj.theta_select),length(d_scan1),length(d_scan2));
              obj.data_a=zeros(length(d_scan1),length(d_scan2));
              obj.angle_scan_flag=0;
            else
              obj. data_eta=zeros(length(d_scan1),length(theta_arr));
              obj.data_R=zeros(length(d_scan1),length(theta_arr));
              obj.angle_scan_flag=1;
            end
        end

        function obj=assign(obj,ref_c,theta_n,rotate_n)
            if rotate_n==1
                obj.mat(1:4,obj.N_single+theta_n)=ref_c.R;
                obj.mat(5:8,obj.N_single+theta_n)=ref_c.T;
            elseif rotate_n==2
                obj.mat(1:4,(1+obj.N_single-theta_n))=ref_c.R;
                obj.mat(5:8,(1+obj.N_single-theta_n))=ref_c.T;            
            elseif rotate_n==3
                obj.matb(1:4,obj.N_single+theta_n)=ref_c.R;
                obj.matb(5:8,obj.N_single+theta_n)=ref_c.T;
            else
                obj.matb(1:4,(1+obj.N_single-theta_n))=ref_c.R;
                obj.matb(5:8,(1+obj.N_single-theta_n))=ref_c.T;   
            end
        end
        function obj=eta(obj)

                %for the transmission e a calculation references
                %https://doi.org/10.1016/j.jqsrt.2020.106904
                %https://doi.org/10.1016/j.ijthermalsci.2022.107457
                obj.a_s=1-obj.mat(1,:)-obj.mat(2,:)-obj.mat(5,:)-obj.mat(6,:);
                obj.a_p=1-obj.mat(3,:)-obj.mat(4,:)-obj.mat(7,:)-obj.mat(8,:);
                
                %the e_s other side minux -t_ps(-thetab)-t_ss(-theta_b)
                obj.e_s=1-flip(obj.mat(1,:))-flip(obj.mat(3,:))-flip(obj.matb(5,:))-flip(obj.matb(7,:));
                obj.e_p=1-flip(obj.mat(2,:))-flip(obj.mat(4,:))-flip(obj.matb(6,:))-flip(obj.matb(8,:));  
                
                obj.a_s(abs(obj.a_s)<obj.delta_ignore)=0;
                obj.a_p(abs(obj.a_p)<obj.delta_ignore)=0;
                obj.e_s(abs(obj.e_s)<obj.delta_ignore)=0;
                obj.e_p(abs(obj.e_p)<obj.delta_ignore)=0;
               
                obj.eta_s=obj.a_s-obj.e_s;
                obj.eta_p=obj.a_p-obj.e_p;
        end

        function obj=manipulate_d(obj,d_1,d_2,theta_arr,ref_c)
            if (obj.angle_scan_flag==0)
                 if isempty(obj.theta_select)
                   %find maximum reciprocity among all angles
                   temp_p=obj.eta_p;
                   %remove angle >85 degree
                   temp_p(abs(theta_arr)>1.5)=0;
                   obj.data_eta(d_1,d_2)=max(temp_p);
                   obj.data_a(d_1,d_2)=theta_arr(temp_p==max(temp_p));  
                 else
                   %find maximum reciprocity at a given angle
                   obj.data_eta(:,d_1,d_2)=obj.eta_p(obj.theta_select);
                   %get the R_pp
                   obj.data_R(d_1,d_2)=ref_c.r(end);
               
                 end
              
            end

        end
  
        function obj=manipulate_angle(obj,d_1,theta_n,ref_c)
            if obj.angle_scan_flag==1
                 obj.data_eta(d_1,theta_n)=obj.eta_p(theta_n);
                 obj.data_R(d_1,theta_n)=ref_c.r(end);  

            end
        end
    
    end
end