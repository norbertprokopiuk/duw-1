% funkcja, ktora oblicza wektor gamma potrzebny w zadaniu o przyspieszeniach
function [ Gamma ] = WektorGamma( q, qdot, t, Wiezy, rows )

wymuszenie=fopen('wymuszenie.txt','r');
for i=1:8
   eval(fgetl(wymuszenie)); 
end
fclose(wymuszenie);

% wypelnienie macierzy samymi zerami
Gamma = zeros(rows, 1);

% stala macierz Omega
Omega = [0 -1; 1 0];

% aktualny numer wiersza macierzy Jacobiego
m=1;
  
for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            Gamma(m, 1) = eval(Wiezy(l).ddotfodt);
            m = m+1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            Gamma(m,1) = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp)'*...
                ( 2*Omega()*( q_r(qdot, Wiezy(l).bodyj) - q_r(qdot, Wiezy(l).bodyi) )*...
                q_phi(qdot, Wiezy(l).bodyj) + ( q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) ) *...
                q_phi(qdot, Wiezy(l).bodyj)*q_phi(qdot, Wiezy(l).bodyj) - ...
                rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA * (q_phi(qdot, Wiezy(l).bodyj) - q_phi(qdot, Wiezy(l).bodyi)) * ...
                (q_phi(qdot, Wiezy(l).bodyj) - q_phi(qdot, Wiezy(l).bodyi))) + eval(Wiezy(l).ddotfodt);
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            Gamma(m:(m+1), 1) = rot(q_phi(q, Wiezy(l).bodyi)) * Wiezy(l).sA * ...
                q_phi(qdot, Wiezy(l).bodyi) * q_phi(qdot, Wiezy(l).bodyi) - ...
                rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).sB * ...
                q_phi(qdot, Wiezy(l).bodyj) * q_phi(qdot, Wiezy(l).bodyj);
            m = m+2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            
            m = m+1;
            
            Gamma(m,1) = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp)'*...
                ( 2*Omega()*( q_r(qdot, Wiezy(l).bodyj) - q_r(qdot, Wiezy(l).bodyi) )*...
                q_phi(qdot, Wiezy(l).bodyj) + ( q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) ) *...
                q_phi(qdot, Wiezy(l).bodyj)*q_phi(qdot, Wiezy(l).bodyj) - ...
                rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA * (q_phi(qdot, Wiezy(l).bodyj) - q_phi(qdot, Wiezy(l).bodyi)) * ...
                (q_phi(qdot, Wiezy(l).bodyj) - q_phi(qdot, Wiezy(l).bodyi)));
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    else
        error(['Blad: zle podany typ wiezu nr', num2str(l)]);
    end
end

end

