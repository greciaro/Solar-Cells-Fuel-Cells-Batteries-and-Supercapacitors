function out = differential(t,y,a,b,k,d,e,g,l,o,r,s)
out = [g*y(3)
    l*y(4)
    (1/a)*(k + d + e*s*y(3)+e*y(1)-b*y(5))
    
    ];
end