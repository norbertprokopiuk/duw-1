%funkcja, ktora oblicza macierz rotacji
function [ R ] = rot( phi )

R = [cos(phi), -sin(phi);
    sin(phi), cos(phi)];
end

