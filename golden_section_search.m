
function x_opt = golden_section_search(f, a, b, tol)
    golden_ratio = (1+sqrt(5))/2;
    c = b - (b - a) / golden_ratio;
    d = a + (b - a) / golden_ratio;
    
    while abs(c - d) > tol
        if f(c) < f(d)
            b = d;
        else
            a = c;
        end
        c = b - (b - a) / golden_ratio;
        d = a + (b - a) / golden_ratio;
    end
    x_opt = (a + b) / 2;
end