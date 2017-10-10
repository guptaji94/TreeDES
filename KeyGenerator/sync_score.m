
function y = sync_score(m1, m2, l)
    y = 1.0 - mean(mean(1.0 * abs(m1.W - m2.W)/(2 * l)));    
end
    