%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Tarik Roukny
%           The Price of Complexity
%
% Produces Figures in a 2 Banks system:
%   - Heat Maps: Probability of Systemic Risk as a function of two
%   parameters
%   - Line of Uncertainty: Set of Solutions within the range of a
%   parameter's range
%
% date: 15/06/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
fontsize           = 16;

heat_maps               = 'on';
uncertainty             = 'on';

print_fig               = 'on';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GENERAL VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default values with realistic leverage
beta_star    = 3;
epsilon_star = 10;

% Parameters for High Systemic Risk
% systems' variables
sigma_star   = 0.005;
ans='high';
if strcmp(ans,'high')
    R_star       = 0.2;
    P_i_star     = 0.4;
    mu_star      = -0.01;

% Parameters for Low Systemic Risk
% systems' variables 
elseif strcmp(ans,'low')
    R_star       = 0.5;
    P_i_star     = 0.1;
    mu_star      = -0.08;
end

epsilon_limit      = 15;
beta_limit         = 10;

PD      = probability_surface_uncorrelated_function (beta_star,epsilon_star,sigma_star,mu_star,R_star,P_i_star);
Psys    = systemic_probability_surface_uncorrelated_function (beta_star,epsilon_star,sigma_star,mu_star,R_star,P_i_star);

string =  sprintf(' $\\beta^*$ = %d \n $\\epsilon^*$ = %d  \n $\\mu^*$ = %0.2f \n $\\sigma^*$ = %0.3f \n $R^*$ = %0.1f \n $P_i^*$ = %0.2f',beta_star, epsilon_star, mu_star, sigma_star, R_star, P_i_star)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEAT MAPS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if heat_maps == 'on'
    
    figureHandle = figure;
    clf;
    set(figureHandle,'defaulttextinterpreter','latex');
    nfigures = 1;
    fontsize=16;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EPSILON
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   MU vs. EPSILON
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    mu      = [-1:0.001:1];
    epsilon = [0.001:0.01:epsilon_limit];
    
    for i = 1:length(mu)
        a =[];
        for j = 1: length(epsilon)
            a(j) = systemic_probability_surface_uncorrelated_function (beta,epsilon(j),sigma,mu(i),R,P_i);
        end
        map_sys (i,:) = a;
    end
    
    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys)
    caxis([0 1])

    xlabel ('$\epsilon$', 'fontsize', fontsize)
    set (gca, 'XTick', [0:epsilon_limit*10:epsilon_limit*100], 'XTickLabel', [0:epsilon_limit/10:epsilon_limit])
    ylabel ('$\mu$','fontsize', fontsize)

    set (gca, 'YTick', [0:200:2000], 'YTickLabel', [-1:1/5:1])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   EPSILON vs. BETA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    epsilon = [0.001:0.01:epsilon_limit];
    beta    = [0.001:0.01:beta_limit];
    
    for i = 1:length(beta)
        a =[];
        for j = 1: length(epsilon)
            a(j) = systemic_probability_surface_uncorrelated_function (beta(i),epsilon(j),sigma,mu,R,P_i);
        end
        map_sys_beta_epsilon (i,:) = a;
    end
    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_beta_epsilon)

    xlabel ('$\epsilon$','fontsize', fontsize)
    set (gca, 'XTick', [0:epsilon_limit*10:epsilon_limit*100], 'XTickLabel', [0:epsilon_limit/10:epsilon_limit])
    ylabel ('$\beta$','fontsize', fontsize)
    set (gca, 'YTick', [0:beta_limit*10:beta_limit*100], 'YTickLabel', [0:beta_limit/10:beta_limit])    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   EPSILON vs. R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    epsilon = [0.001:0.01:epsilon_limit];
    R       = [0.000001:0.001:1];
    
    for i = 1:length(R)
        a =[];
        for j = 1: length(epsilon)
            a(j) = systemic_probability_surface_uncorrelated_function (beta,epsilon(j),sigma,mu,R(i),P_i);
        end
        map_sys_R_epsilon (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_R_epsilon)

    xlabel ('$\epsilon$','fontsize', fontsize)
    set (gca, 'XTick', [0:epsilon_limit*10:epsilon_limit*100], 'XTickLabel', [0:epsilon_limit/10:epsilon_limit])
    ylabel ('$R$','fontsize', fontsize)
    set (gca, 'YTick', [0:100:1000], 'YTickLabel', [0:1/10:1])  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   EPSILON vs. Pi
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    epsilon = [0.001:0.01:epsilon_limit];
    P_i     = [0.000001:0.001:1];
    
    for i = 1:length(P_i)
        a =[];
        for j = 1: length(epsilon)
            a(j) = systemic_probability_surface_uncorrelated_function (beta,epsilon(j),sigma,mu,R,P_i(i));
        end
        map_sys_P_i_epsilon (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_P_i_epsilon)
    
    hp4 = get(subplot(2,2,4),'Position')
    hcb = colorbar ('Position',[hp4(1)+hp4(3)+0.02  hp4(2)  0.04  hp4(2)+hp4(3)*2.1]) ;
    colormap(autumn)
    colormap(flipud(colormap))
    title(hcb, '$P^{sys}$','rot',0,'fontsize', fontsize);
    caxis([0 1])

    xlabel ('$\epsilon$','fontsize', fontsize)
    set (gca, 'XTick', [0:epsilon_limit*10:epsilon_limit*100], 'XTickLabel', [0:epsilon_limit/10:epsilon_limit])
    ylabel ('$P^0$','fontsize', fontsize)
    set (gca, 'YTick', [0:100:1000], 'YTickLabel', [0:1/10:1])  
    
    if print_fig == 'on'
        print -depsc2 heatmap_epsilon.eps;
        fixPSlinestyle('heatmap_epsilon.eps', 'heatmap_epsilon.eps');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CHANGE VARIABLE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figureHandle = figure;
    clf;
    set(figureHandle,'defaulttextinterpreter','latex');
    nfigures = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BETA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   MU vs. BETA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    mu      = [-1:0.001:1];
    beta    = [0.001:0.01:beta_limit];
    
    for i = 1:length(mu)
        a =[];
        for j = 1: length(beta)
            a(j) = systemic_probability_surface_uncorrelated_function (beta(j),epsilon,sigma,mu(i),R,P_i);
        end
        map_mu_beta (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_mu_beta)
    caxis([0 1])

    xlabel ('$\beta$','fontsize', fontsize)
    set (gca, 'XTick', [0:beta_limit*10:beta_limit*100], 'XTickLabel', [0:beta_limit/10:beta_limit])
    ylabel ('$\mu$','fontsize', fontsize)
    set (gca, 'YTick', [0:200:2000], 'YTickLabel', [-1:1/5:1])
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   EPSILON vs. BETA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    epsilon = [0.001:0.01:epsilon_limit];
    beta    = [0.001:0.01:beta_limit];
    
    for i = 1:length(epsilon)
        a =[];
        for j = 1: length(beta)
            a(j) = systemic_probability_surface_uncorrelated_function (beta(j),epsilon(i),sigma,mu,R,P_i);
        end
        map_sys_epsilon_beta (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_epsilon_beta)
    caxis([0 1])

    xlabel ('$\beta$','fontsize', fontsize)
    set (gca, 'XTick', [0:beta_limit*10:beta_limit*100], 'XTickLabel', [0:beta_limit/10:beta_limit])
    ylabel ('$\epsilon$','fontsize', fontsize)
    set (gca, 'YTick', [0:epsilon_limit*10:epsilon_limit*100], 'YTickLabel', [0:epsilon_limit/10:epsilon_limit])    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   BETA vs. R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    beta    = [0.001:0.01:beta_limit];
    R       = [0.000001:0.001:1];
    
    for i = 1:length(R)
        a =[];
        for j = 1: length(beta)
            a(j) = systemic_probability_surface_uncorrelated_function (beta(j),epsilon,sigma,mu,R(i),P_i);
        end
        map_sys_R_beta (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_R_beta)
    caxis([0 1])

    xlabel ('$\beta$','fontsize', fontsize)
    set (gca, 'XTick', [0:beta_limit*10:beta_limit*100], 'XTickLabel', [0:beta_limit/10:beta_limit])
    ylabel ('$R$','fontsize', fontsize)
    set (gca, 'YTick', [0:100:1000], 'YTickLabel', [0:1/10:1])  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   EPSILON vs. Pi
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star;  
    
    beta    = [0.001:0.01:beta_limit];
    P_i     = [0.000001:0.001:1];
    
    for i = 1:length(P_i)
        a =[];
        for j = 1: length(beta)
            a(j) = systemic_probability_surface_uncorrelated_function (beta(j),epsilon,sigma,mu,R,P_i(i));
        end
        map_sys_P_i_beta (i,:) = a;
    end

    subplot(2,2,nfigures)
    nfigures = nfigures + 1;
    imagesc(map_sys_P_i_beta)

    hp4 = get(subplot(2,2,4),'Position')
    hcb = colorbar ('Position',[hp4(1)+hp4(3)+0.02  hp4(2)  0.04  hp4(2)+hp4(3)*2.1]) ;
    colormap(autumn)
    colormap(flipud(colormap))
    title(hcb, '$P^{sys}$','rot',0,'fontsize', fontsize);
    caxis([0 1])
    
    xlabel ('$\beta$','fontsize', fontsize)
    set (gca, 'XTick', [0:beta_limit*10:beta_limit*100], 'XTickLabel', [0:beta_limit/10:beta_limit])
    ylabel ('$P^{0}$','fontsize', fontsize)
    set (gca, 'YTick', [0:100:1000], 'YTickLabel', [0:1/10:1])  
    
    if print_fig == 'on'
        print -depsc2 heatmap_beta.eps;
        fixPSlinestyle('heatmap_beta.eps', 'heatmap_beta.eps');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINE OF UNCERTAINTY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if uncertainty == 'on'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   INDIVIDUAL EFFECT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figureHandle = figure
    clf;
    
    beta    = beta_star;
    epsilon = epsilon_star;
    sigma   = sigma_star;
    mu      = mu_star;
    R       = R_star;    
    P_i     = P_i_star; 
    fontsize=16;
    
    percentage = [0:1:50];
    percentage_beta = [0:1.1:55];
    for i  = 1:length(percentage)

        range = [1-percentage(i)/100:percentage(i)/1000:1+percentage(i)/100];
        range_beta_x = [1-percentage_beta(i)/100:percentage_beta(i)/1000:1+percentage_beta(i)/100];
        
        if i == 1
            range_epsilon = [epsilon];
            range_sigma   = [sigma];
            range_mu      = [mu];
            range_beta    = [beta];
            range_R       = [R];
            range_P_i     = [P_i];
        else
            range_epsilon   = epsilon * range;
            range_sigma     = sigma * range;
            range_mu        = mu * range;
            range_beta      = beta * range_beta_x;
            range_R         = R * range;
            range_P_i       = P_i * range;
        end
                
        for j = 1:length(range_epsilon)
            Psys_epsilon(j) = systemic_probability_surface_uncorrelated_function (beta,range_epsilon(j),sigma,mu,R,P_i);
            Psys_sigma(j)   = systemic_probability_surface_uncorrelated_function (beta,epsilon,range_sigma(j),mu,R,P_i);
            Psys_mu(j)      = systemic_probability_surface_uncorrelated_function (beta,epsilon,sigma,range_mu(j),R,P_i);
            Psys_beta(j)    = systemic_probability_surface_uncorrelated_function (range_beta(j),epsilon,sigma,mu,R,P_i);
            Psys_R(j)       = systemic_probability_surface_uncorrelated_function (beta,epsilon,sigma,mu,range_R(j),P_i);
            Psys_P_i(j)     = systemic_probability_surface_uncorrelated_function (beta,epsilon,sigma,mu,R,range_P_i(j));
        end

        maxPsys_epsilon(i)  = max(Psys_epsilon);
        minPsys_epsilon(i)  = min(Psys_epsilon);
        maxPsys_sigma(i)    = max(Psys_sigma);
        minPsys_sigma(i)    = min(Psys_sigma);
        maxPsys_mu(i)       = max(Psys_mu);
        minPsys_mu(i)       = min(Psys_mu);
        maxPsys_beta(i)     = max(Psys_beta);
        minPsys_beta(i)     = min(Psys_beta);
        maxPsys_R(i)        = max(Psys_R);
        minPsys_R(i)        = min(Psys_R);
        maxPsys_P_i(i)      = max(Psys_P_i);
        minPsys_P_i(i)      = min(Psys_P_i);
        
    end
    
    hold
    C = linspecer(9) 
    h = zeros(1,4);
    
    %%%% epsilon %%%%
    col_i = C(1,:);
    h(1) = plot(percentage, maxPsys_epsilon, '-','color',col_i, 'DisplayName','\epsilon','LineWidth',5);
    plot(percentage, minPsys_epsilon, '-','color',col_i, 'LineWidth',5) ; 
    
    fil = plot(percentage(2:4:end), maxPsys_epsilon(2:4:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(2:4:end), minPsys_epsilon(2:4:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    
    %%%% mu %%%%
    col_i = C(5,:);
    h(2) = plot(percentage, maxPsys_mu, '-','color',col_i,'DisplayName','\mu','LineWidth',5);
    plot(percentage, minPsys_mu, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage(1:4:end), maxPsys_mu(1:4:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(1:4:end), minPsys_mu(1:4:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
   
    %%%% sigma %%%%
    col_i = C(4,:);
    h(3) = plot(percentage, maxPsys_sigma, '-','color',col_i,'DisplayName','\sigma','LineWidth',5);
    plot(percentage, minPsys_sigma, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage(1:4:end), maxPsys_sigma(1:4:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(1:4:end), minPsys_sigma(1:4:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)

    %%%% beta %%%%
    col_i = C(2,:);
    h(4) = plot(percentage_beta, maxPsys_beta, '-','color',col_i,'DisplayName','\beta','LineWidth',5);
    plot(percentage_beta, minPsys_beta, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage_beta(1:3:end), maxPsys_beta(1:3:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage_beta(1:3:end), minPsys_beta(1:3:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    
    %%%% R %%%%   
    col_i = C(9,:);
    h(5) = plot(percentage, maxPsys_R, '-','color',col_i,'DisplayName','R','LineWidth',5);
    plot(percentage, minPsys_R, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage(2:3:end), maxPsys_R(2:3:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(2:3:end), minPsys_R(2:3:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)

    %%%% P %%%%
    
    col_i = C(7,:);
    h(6) = plot(percentage, maxPsys_P_i, '-','color',col_i,'DisplayName','P^0','LineWidth',5);
    plot(percentage, minPsys_P_i, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage(3:3:end), maxPsys_P_i(3:3:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(3:3:end), minPsys_P_i(3:3:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)    
      
    xlabel ('Relative Error  in Percentage','fontsize', fontsize)
    xlim([0 50]);
    ylabel ('P^{sys}','fontsize', fontsize)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   COMBINED EFFECT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    percentage = [0:1:50];

    for i  = 1:length(percentage)

        range = [1-percentage(i)/100:percentage(i)/200:1+percentage(i)/100];
        
        if i == 1
            range_epsilon = [epsilon];
            range_sigma   = [sigma];
            range_mu      = [mu];
            range_beta    = [beta];
            range_R       = [R];
            range_P_i     = [P_i];
        else
            range_epsilon   = epsilon * range;
            range_sigma     = sigma * range;
            range_mu        = mu * range;
            range_beta      = beta * range;
            range_R         = R * range;
            range_P_i       = P_i * range;
        end
        
        count = 1;
        for m = 1:length(range_epsilon)
            for n = 1:length(range_sigma)
                for o = 1:length(range_beta)
                    for p = 1:length(range_R)
                        for q = 1:length(range_P_i)
                            for r = 1:length(range_mu)
                                if range_beta(o) < 0
                                    range_beta(o) = 0;
                                end
                                if range_epsilon(m) < 0
                                    range_epsilon(m) = 0;
                                end
                                if range_sigma(n) < 0
                                    range_sigma(n) = 0;
                                end
                                if range_R(p) < 0
                                    range_R(p) = 0;
                                end
                                if range_P_i(q) < 0
                                    range_P_i(q) = 0;
                                end
                                Psys_general(count) = systemic_probability_surface_uncorrelated_function (range_beta(o),range_epsilon(m),range_sigma(n),range_mu(r),range_R(p),range_P_i(q));
                                count = count + 1;
                            end
                        end
                    end
                end
            end
        end
        
        frequency(i,:) = hist(Psys_general, 0:0.05:1);

        maxPsys_general(i)  = max(Psys_general);
        minPsys_general(i)  = min(Psys_general);    
    end

    h(7) = plot (percentage, minPsys_general,':','color',C(3,:), 'DisplayName','all', 'LineWidth',2)

    % EPSILON
    
    col_i = C(1,:);
    h(1) = plot(percentage, maxPsys_epsilon, '-','color',col_i, 'DisplayName','\epsilon','LineWidth',5);
    plot(percentage, minPsys_epsilon, '-','color',col_i, 'LineWidth',5) ; 
    
    fil = plot(percentage(2:4:end), maxPsys_epsilon(2:4:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage(2:4:end), minPsys_epsilon(2:4:end), 'o','color',col_i,'LineWidth',5) ;  

    % BETA
    
    col_i = C(2,:);
    h(4) = plot(percentage_beta, maxPsys_beta, '-','color',col_i,'DisplayName','\beta','LineWidth',5);
    plot(percentage_beta, minPsys_beta, '-','color',col_i, 'LineWidth',5);
    
    fil = plot(percentage_beta(1:3:end), maxPsys_beta(1:3:end), 'o','color',col_i,'LineWidth',5);
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    fil = plot(percentage_beta(1:3:end), minPsys_beta(1:3:end), 'o','color',col_i,'LineWidth',5) ;  
    set(fil,'MarkerEdgeColor',col_i,'MarkerFaceColor',col_i)
    
    %%%PAUSE%%%
    
    h_leg=legend(h(:), 'Location', 'northeast')
    set(h_leg,'fontsize', fontsize)
    
    if print_fig == 'on'
        print -depsc2 uncertainty_general.eps;
        fixPSlinestyle('uncertainty_general.eps', 'uncertainty_general.eps');
    end    
end


