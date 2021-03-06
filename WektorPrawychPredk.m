% funkcja, ktora wyznacza prawe stron w rownaniach  
function [ Prawe ] = WektorPrawychPredk( q, t, Wiezy, rows )

wymuszenie=fopen('wymuszenie.txt','r');
for i=1:8
   eval(fgetl(wymuszenie)); 
end
fclose(wymuszenie);
% wypełnienie macierzy samymi zerami
Prawe = zeros(rows, 1);

% aktualny numer wiersza macierzy
m=1;

% wypełnienie macierzy niezerowymi elementami
for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            Prawe(m) = eval(Wiezy(l).dotfodt);
            m=m+1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            Prawe(m) = eval(Wiezy(l).dotfodt);
            m=m+1;
        end
    end
    if(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            m=m+2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            m=m+2;
        end
    end
end

end

