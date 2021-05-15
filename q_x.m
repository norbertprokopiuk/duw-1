% funkcja, ktora zwraca wspolrzedna x ciala numer i
function [ x ] = q_x( q, i )

if(i==0)
    x = 0;
else
    x = q(3*i-2);
end


end

