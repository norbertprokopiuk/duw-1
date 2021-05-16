% glowny program - rozwiazuje zadania kinematyki o polozeniu, predkosci i przyspieszeniu 
% struktura do przechowywania wiezow 
% Wiezy = struct('typ',{},...
%     'klasa',{},... % jak to para? para postepowa czy obrotowa 
%     'bodyi',{},... %  nr pierwszego ciala
%     'bodyj',{},... % nr drugiego ciala
%     'sA',{},... % wektor sA w i-tym ukladzie (cialo i)
%     'sB',{},... % wektor sB w j-tym ukladzie (cialo j)
%     'phi0',{},... % kat phi0 (gdy pary postepowa)
%     'perp',{},... % wersor prostopadly do osi ruchu w ukladzie j-tym (gdy pary postepowa)
%     'fodt',{},... % funkcja od czasu dla wiezow dopisanych
%     'dotfodt',{},... % pochodna funkcji od czasu dla wiezow dopisanych
%     'ddotfodt',{}); % druga pochodna funkcji od czasu dla wiezow
%     dopisanych
close all;clc;clear
pobierz_dane;
% zmienna do wyznaczania liczby rownan wiezow 
rows = 0;

for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            rows = rows + 1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            rows = rows + 1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            rows = rows + 2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            rows = rows + 2;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    else
        error(['Blad: zle podana typ wiezu nr', num2str(l)]);
    end
end


% T to tablica do zapisu kolejnych chwil
% Q to tablica do zapisu rozwiazan zadania o polozeniu w kolejnych chwilach
% DQ to tablica do zapisu rozwiazan zadania o predkosci w kolejnych chwilach
% D2Q to tablica do zapisu rozwiazan zadania o przyspieszeniu w kolejnych chwilach

q=zeros(3*length(srodki_ciezkosci),1);
for i=0:length(srodki_ciezkosci)-1
   q(1+i*3)= srodki_ciezkosci(i+1,1);
   q(2+i*3)= srodki_ciezkosci(i+1,2);
   q(3+i*3)= 0;
end
qdot=zeros(size(q));
qddot=zeros(size(q));

lroz=0; % licznik rozwiazan (sluzy do numerowania kolumn w tablicach z wynikami)
dt=0.01; % odstep pomiedzy kolejnymi chwilami

ZakresCzasu = 0:dt:2;
Q = zeros(size(q,1), length(ZakresCzasu));
DQ = zeros(size(Q));
D2Q = zeros(size(Q));
T = zeros(size(Q));

% rozwiazywanie zadan kinematyki w kolejnych chwilach t
for t=ZakresCzasu
    % zadanie o polozeniu, gdzie przyblizeniem poczatkowym jest rozwiazanie z poprzedniej chwili, 
    % powiekszone o skladniki wynikajace z obliczonej predkości i przyspieszenia.
    q0=q+qdot*dt+0.5*qddot*dt*dt;
    q=NewtonRaphson(q0,t,Wiezy,rows); 

    % zadanie o predkosci
    qdot=Jakobian(q,t,Wiezy,rows)\WektorPrawychPredk(q,t,Wiezy,rows); 

    % zadanie o przyspieszeniu
    qddot=Jakobian(q,t,Wiezy,rows)\WektorGamma(q,qdot,t,Wiezy,rows);  

    % zapis do tablic
    lroz
    lroz=lroz+1;
    T(1,lroz)=t; 
    Q(:,lroz)=q;
    DQ(:,lroz)=qdot;
    D2Q(:,lroz)=qddot;
end
postprocessor;





    