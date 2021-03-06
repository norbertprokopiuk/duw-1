% wektor rowana wiezow
function [ Phi ] = WektorPhi( q, t, Wiezy, rows )

wymuszenie=fopen('wymuszenie.txt','r');
for i=1:8
   eval(fgetl(wymuszenie)); 
end
fclose(wymuszenie);
% aktualny numer wiersza macierzy
m = 1;
% wypelnienie macierzy samymi zerami
Phi = zeros(rows, 1);

% wypelnienie macierzy niezerowymi elementami   
for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            Phi(m, 1) = q_phi(q, Wiezy(l).bodyi) - q_phi(q, Wiezy(l).bodyj) - ...
                eval(Wiezy(l).fodt);
            m = m+1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            Phi(m,1) = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp)'*...
                ( q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) - ...
                rot(q_phi(q, Wiezy(l).bodyi)) * Wiezy(l).sA ) + ...
                (Wiezy(l).perp)'*Wiezy(l).sB - eval(Wiezy(l).fodt);
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            Phi(m:(m+1), 1) = q_r(q, Wiezy(l).bodyi) - q_r(q, Wiezy(l).bodyj) + ...
                rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA - ...
                rot(q_phi(q, Wiezy(l).bodyj))*Wiezy(l).sB;
            m = m+2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            Phi(m, 1) = q_phi(q, Wiezy(l).bodyi) - q_phi(q, Wiezy(l).bodyj) - ...
                Wiezy(l).phi0;
            m = m+1;
            Phi(m,1) = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp)'*...
                ( q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) - ...
                rot(q_phi(q, Wiezy(l).bodyi)) * Wiezy(l).sA ) + ...
                (Wiezy(l).perp)'*Wiezy(l).sB;
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    else
        error(['Blad: zle podany typ wiezu nr', num2str(l)]);
    end
end


end

