%phi_map function

function [y] = phi_map(beta,epsilon,sigma,mu,x)
y = (-1 + beta*(x) - mu*epsilon)/((sigma)*epsilon);