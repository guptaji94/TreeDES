function W = hebbian(W, X, sigma, tau1, tau2, l)
    k = size(W,1);
    n = size(W,2);
    
    for i = 1:k
        for j = 1:n
            W(i,j) = W(i,j)  + X(i, j) .* tau1 .* theta(sigma(j), tau1) .* theta(tau1, tau2); 
            W(i,j) = clip(W(i,j),-l,l);
        end
    end
end
