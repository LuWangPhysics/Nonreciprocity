classdef my_plot
properties
end
methods
    function angle_scan(obj,theta_half,data_mat,savename)
        theta=[-flip(theta_half),theta_half].*180./pi;
        figure

        subplot(2,2,1);
        plot(theta,data_mat(1:2,:))
        xlim([-90,90])
        ylabel("R reflection")
      % title(['\epsilon_{xy}=i' num2str(imag(eps_xy))])
        xlabel("incidence angle")
        legend("ss","sp")

        subplot(2,2,2)
        plot(theta,data_mat(3:4,:))
        xlim([-90,90])
        ylabel("R reflection")
      % title(['\epsilon_{xy}=i' num2str(imag(eps_xy))])
        xlabel("incidence angle")
        legend("ps","pp")
       
        subplot(2,2,3)
        plot(theta,data_mat(5:6,:))
        xlim([-90,90])
        ylabel("T transmission")
      % title(['\epsilon_{xy}=i' num2str(imag(eps_xy))])
        xlabel("incidence angle")
        legend("ss","sp")


        subplot(2,2,4)
        plot(theta,data_mat(7:8,:))
        xlim([-90,90])
        ylabel("T transmission")
      % title(['\epsilon_{xy}=i' num2str(imag(eps_xy))])
        xlabel("incidence angle")
        legend("ps","pp")
        
        filename=[savename '/RT']; 
        saveas(gcf,[filename '.fig'])
    end



    function a_e(obj, theta_half,D,savename)
         theta=[-flip(theta_half),theta_half].*180./pi;
         figure
        plot(theta,D.a_s)
        hold on
        plot(theta,D.e_s,'--')
        xlim([-90,90])
        ylabel("s-polarized")
        %xlim([0,90])
        ylim([-1,1])
        xlabel("incidence angle")

        legend("a_s","e_s")
        filename=[savename '/eANDa_s']; 
        saveas(gcf,[filename '.fig'])
         figure
        plot(theta,D.a_p)
        hold on
        plot(theta,D.e_p,'--')
        xlim([-90,90])
        ylabel("p-polarized")
        %xlim([0,90])
        ylim([-1,1])
        xlabel("incidence angle")

        legend("a_p","e_p")

        filename=[savename '/eANDa_p']; 
        saveas(gcf,[filename '.fig'])

        figure
        plot(theta,D.eta_s)
        hold on
        plot(theta,D.eta_p,'--')
        ylabel("a-e")
        xlim([-90,90])
        ylim([-1,1])
        xlabel("incidence angle")

        legend("a_s-e_s","a_p-e_p")

        filename=[savename '/eta']; 
        saveas(gcf,[filename '.fig'])

    end

end
end