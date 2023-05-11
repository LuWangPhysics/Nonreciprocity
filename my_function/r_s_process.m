function s=r_s_process(M,Rot,delta_ignore)
%inverse(r2)*M*r1

T_matrix=inv(Rot.R2)*M*Rot.R1;

s=struct;
s.name=["ss","sp","ps","pp"];

de_1=T_matrix(4,4)*T_matrix(3,3)-T_matrix(4,3)*T_matrix(3,4);
%r_ps means refledtion from p to s
r_ss=(T_matrix(4,1)*T_matrix(3,4)-T_matrix(3,1)*T_matrix(4,4))/de_1;
r_sp=(T_matrix(3,1)*T_matrix(4,3)-T_matrix(3,3)*T_matrix(4,1))/de_1;
r_ps=(T_matrix(4,2)*T_matrix(3,4)-T_matrix(4,4)*T_matrix(3,2))/de_1;
r_pp=(T_matrix(3,2)*T_matrix(4,3)-T_matrix(3,3)*T_matrix(4,2))/de_1;

t_ss=T_matrix(1,1)+T_matrix(1,3)*r_ss+T_matrix(1,4)*r_sp;
t_sp=T_matrix(2,1)+T_matrix(2,3)*r_ss+T_matrix(2,4)*r_sp;
t_ps=T_matrix(1,2)+T_matrix(1,3)*r_ps+T_matrix(1,4)*r_pp;
t_pp=T_matrix(2,2)+T_matrix(2,3)*r_ps+T_matrix(2,4)*r_pp;



s.r=[r_ss,r_sp,r_ps,r_pp];
s.t=[t_ss,t_sp,t_ps,t_pp];

s.R=abs(s.r).^2;

s.R(abs(s.R)<delta_ignore)=0;
%coefficint re(kz2/kz1)
s.T=real(Rot.n2*cos(Rot.theta2)/cos(Rot.theta1)/Rot.n1).*abs(s.t).^2;
s.T(abs(s.T)<delta_ignore)=0;

end