%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Tarik Roukny
%
% This function computes the probality of systemic default based on the
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

function [PD] = systemic_probability_surface_uncorrelated_function (beta,epsilon,sigma,mu,R,P_i)

% 1 - compute variables
u_minus     = phi_map(beta, epsilon, sigma, mu, 0);
ui_limit    = phi_map(beta, epsilon, sigma, mu, (1-R));
uj_limit    = phi_map(beta, epsilon, sigma, mu, (1-R)*P_i);

systemic_limit = min(ui_limit, uj_limit);

% NOTE: this could be removed as uj_limit will always be smaller then ui_limit
% due to the '*P' element

% 2 - investigate conditions to get the proper surface formula
%       and compute the width and height

%   A) compute the length depending on systemic_limit

if systemic_limit <-1
    length = 0;
elseif systemic_limit > 1
    length = 2;
else
    length = abs(-1 - systemic_limit);
end

surface = length*length;

% 3 - compute the probability of default of bank i as the ratio btw
%       computed surface and the total surface of the square [-1 1 -1 1] = 4

PD = surface / 4;
