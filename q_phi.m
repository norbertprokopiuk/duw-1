% funkcja, ktora zwraca polozenie katowe ciala numer i
function [ phi ] = q_phi( q, i )

if(i==0)
    phi = 0;
else
    phi = q(3*i);
end
end

