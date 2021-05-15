% wektor rowana wiezow
function [ Phi ] = WektorPhi( q, t, Wiezy, rows )

% wczytanie danych
PSP_dane_silownik;

% aktualny numer wiersza macierzy
m = 1;

% wypelnienie macierzy samymi zerami
Phi = zeros(rows, 1);

% wypelnienie macierzy niezerowymi elementami   
for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ(1)) == 'd')
        if(lower(Wiezy(l).klasa(1)) == 'o')
            Phi(m, 1) = q_phi(q, Wiezy(l).bodyi) - q_phi(q, Wiezy(l).bodyj) - ...
                eval(Wiezy(l).fodt);
            m = m+1;
        elseif(lower(Wiezy(l).klasa(1)) == 'p')
            Phi(m,1) = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp)'*...
                ( q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) - ...
                rot(q_phi(q, Wiezy(l).bodyi)) * Wiezy(l).sA ) + ...
                (Wiezy(l).perp)'*Wiezy(l).sB - eval(Wiezy(l).fodt);
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ(1)) == 'k')
        if(lower(Wiezy(l).klasa(1)) == 'o')
            Phi(m:(m+1), 1) = q_r(q, Wiezy(l).bodyi) - q_r(q, Wiezy(l).bodyj) + ...
                rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA - ...
                rot(q_phi(q, Wiezy(l).bodyj))*Wiezy(l).sB;
            m = m+2;
        elseif(lower(Wiezy(l).klasa(1)) == 'p')
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

