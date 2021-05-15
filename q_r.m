% funkcja, ktora zwraca wektor r ciala numer i
function [ r ] = q_r( q, i )

if(i==0)
    r = [0;0];
else
    r = [q(3*i-2); 
    q(3*i-1)];
end

end

