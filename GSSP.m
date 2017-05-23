function u = GSSP(w,lambda,k)
% function. Let Omega denote the simplex: 
% Omega = {x in R^n: x_i >= 0 and sum x_i = lambda } and let Sigma_k denote
% the set of all k-sparse vectors. This functions projects w on to Omega
% intersect Sigma_k. Based on Kyrillidis et al 'Sparse Projections on to 
% the Simplex' 2013, JMLR.
% INPUT: vector x and (scalar) parameter lambda and sparsity k
% OUTPUT: w in simplex.
 
function v2 = Plambda(v1,sigma)
    [vtemp,inds] = sort(v1,'descend');
    rho = 0;
    StopCond = 1;
    j = 1;
    while StopCond && j <= length(vtemp)
        tau = (sum(vtemp(1:j)) - sigma)/j;
        if vtemp(j) > tau
            rho = rho +1;
            j = j +1;
        else
            StopCond = 0;
        end
    end
    tau = (sum(vtemp(1:rho)) - sigma)/rho;
    vtemp2 = bsxfun(@max,vtemp - tau,0);
    v2 = zeros(size(v1));
    v2(inds) = vtemp2;
end

N = length(w);
[~,indices] = sort(w,'descend');
S = indices(1:k);
u = zeros(N,1);
utemp = Plambda(w(S),lambda);
u(S) = utemp;
end


