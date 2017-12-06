function [x,fun_val]=PGMB(f,g,P,x0,s,alpha,beta,epsilon)
% Projected Gradient method with backtracking stepsize rule
% Based on code from Beck's 'Introduction to Nonlinear Optimization...'
% Modified by Daniel Mckenzie
% 5th December 2017
%
% INPUT
%=======================================
% f ......... objective function
% g ......... gradient of the objective function
% P ......... Projection on to (convex) constraint set
% x0......... initial point
% s ......... initial choice of stepsize
% alpha ..... tolerance parameter for the stepsize selection
% beta ...... the constant in which the stepsize is multiplied 
%             at each backtracking step (0<beta<1)
% epsilon ... tolerance parameter for stopping rule
% OUTPUT
%=======================================
% x ......... optimal solution (up to a tolerance) 
%             of min f(x)
% fun_val ... optimal function value
x=x0;
grad=g(x);
fun_val=f(x);
iter=0;
while (norm(grad)>epsilon)
    iter=iter+1;
    t=s;
    while (fun_val-f(x-t*grad)<alpha*t*norm(grad)^2)
        t=beta*t;
    end
    x=P(x-t*grad);
    fun_val=f(x);
    grad=g(x);
    fprintf('iter_number = %3d norm_grad = %2.6f fun_val = %2.6f \n',iter,norm(grad),fun_val);
end
