function [ R ] = rot( phi )

R = [cos(phi), -sin(phi);
    sin(phi), cos(phi)];
end

%funkcja służąca do obliczania macierzy rotacji
%fi - kąt w radianach