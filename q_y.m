% funkcja, ktora zwraca wspolrzedna y ciala numer i
function [ y ] = q_y( q, i )

if(i==0)
    y = 0;
else
    
    y = q(3*i-1);
end

end