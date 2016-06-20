%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Tarik Roukny
%
% This function computes the probality of default of one bank based on the
% surface computation in a 2 banks set up
% INPUTS: 
% - IB exposure beta
% - External asset exposure epsilon
% - Shock value sigma
% - Recovery Rate R
% - Probability of default of the counterparty P_i
%
% date: 15/06/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [PD] = probability_surface_uncorrelated_function (beta,epsilon,sigma,mu,R,P_i)

% 1 - compute variables
u_minus     = phi_map(beta, epsilon, sigma, mu, 0);
ui_limit    = phi_map(beta, epsilon, sigma, mu, (1-R));
uj_limit    = phi_map(beta, epsilon, sigma, mu, (1-R)*P_i);

% 2 - investigate conditions to get the proper surface formula
%       and compute the width and height

%   A) compute the width depending on uj_limit

if uj_limit <-1
    width = 0;
elseif uj_limit > 1
    width = 2;
else
    width = abs(-1 - uj_limit);
end

%   B) compute the height depending on ui_limit

if ui_limit <-1
    height = 0;
elseif ui_limit > 1
    height = 2;
else
    height = abs(-1 - ui_limit);
end
surface = width*height;

%   C) Check if u_minus is in the scope of results
%           - if yes:   compute the related surface,
%                       sum the 2 surfaces,
%                       remove the overlap

if u_minus <1 && u_minus > -1
    % compute width and height of the u_minus
    height_minus     = 2;
    width_minus     = abs(-1 - u_minus);
    surface_minus   = width_minus * height_minus;
    
    %remove the overlapping surface
    width_overlap   = width_minus;
    height_overlap  = height;
    surface_overlap = width_overlap*height_overlap;
    
    surface = surface + surface_minus - surface_overlap;
end

% 3 - compute the probability of default of bank i as the ratio btw
%       computed surface and the total surface of the square [-1 1 -1 1] = 4

PD = surface / 4;
