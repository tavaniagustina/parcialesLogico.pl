% cantante(nombre, cante(nombreCancion, duracion)).
cantante(megurineLuka, canta(nightFever, 4)).
cantante(megurineLuka, canta(foreverYoung, 5)).
cantante(hatsuneMiku, canta(tellYourWorld, 4)).
cantante(gumi, canta(foreverYoung, 4)).
cantante(gumi, canta(tellYourWorld, 5)).
cantante(seeU, canta(novemberRain, 6)).
cantante(seeU, canta(nightFever, 5)).

% 1

esNovedoso(Cantante) :-
   sabeAlMenosDosCanciones(Cantante),
   tiempoTotalCanciones(Cantante, Tiempo),
   Tiempo < 15.

sabeAlMenosDosCanciones(Cantante) :-
    cantante(Cantante, UnaCancion),
    cantante(Cantante, OtraCancion),
    UnaCancion \= OtraCancion.

tiempoTotalCanciones(Cantante, TiempoTotal) :-
    findall(TiempoCancion, cantante(Cantante, canta(_, TiempoCancion)), Tiempos),
    sumlist(Tiempos, TiempoTotal).

% 2

esAcelerado(Cantante) :-
    cantante(Cantante, _),
    not((tiempoDeCancion(Cantante, Tiempo), Tiempo > 4)).

tiempoDeCancion(Cantante, Tiempo) :-
    cantante(Cantante, Cancion),
    tiempo(Cancion, Tiempo).

tiempo(canta(_, Tiempo), Tiempo).

% Si nos permitieran usar el forall/2 acá nos quedaría en vez del not/1:
% forall(tiempoDeCancion(Cantante,Tiempo), Tiempo <= 4).

% concierto(nombre, pais, fama, tipo).
% tipo -> 
% gigante(cantidadMinimaDeCanciones, duracionTotalMinima)
% mediano(maximaDuracionTotalMinutos)
% pequenio(algunaCancionConMasDuracion)

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% 2

puedeParticipar(hatsuneMiku, Conciento) :-
    concierto(Conciento, _, _, _).
  
puedeParticipar(Cantante, Conciento) :-
    cantante(Cantante, _),
    Cantante \= hatsuneMiku,
    concierto(Conciento, _, _, Requesitos),
    cumpleRequisitos(Cantante, Requesitos).

cumpleRequisitos(Cantante, gigante(cantidadMinimaDeCanciones, duracionTotalMinima)) :-
    cantidadDeCanciones(Cantante, Cantidad),
    Cantidad >= cantidadMinimaDeCanciones,
    tiempoTotalCanciones(Cantante, Tiempo),
    Tiempo >= duracionTotalMinima.

cumpleRequisitos(Cantante, mediano(maximaDuracionTotalMinutos)) :-
    tiempoTotalCanciones(Cantante, Tiempo),
    Tiempo < maximaDuracionTotalMinutos.

cumpleRequisitos(Cantante, pequenio(algunaCancionConMasDuracion)) :-
    cantante(Cantante, Cancion),
    tiempo(Cancion, Tiempo),
    Tiempo > algunaCancionConMasDuracion.

cantidadDeCanciones(Cantante, Cantidad) :-
    findall(Cancion, cantante(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

% 3

masFamoso(Cantante) :-
    nivelFamoso(Cantante, NivelMasFamoso),
    forall(nivelFamoso(_, Nivel), NivelMasFamoso >= Nivel).
    
nivelFamoso(Cantante, Nivel) :-
    famaTotal(Cantante, Fama),
    cantidadDeCanciones(Cantante, Cantidad),
    Nivel is Fama * Cantidad.

famaTotal(Cantante, FamaTotal) :-
    cantante(Cantante, _),
    findall(Fama, famaConcierto(Cantante, Fama), CantidadesDeFama),
    sumlist(CantidadesDeFama, FamaTotal).

famaConcierto(Cantante, Fama) :-
    puedeParticipar(Cantante, Conciento),
    fama(Conciento, Fama).

fama(Conciento, Fama) :-
    concierto(Conciento, _, Fama, _).

% 4

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipanteEntreConocidos(Cantante, Conciento) :-
    puedeParticipar(Cantante, Conciento),
    not(conocido(Cantante, OtroCantante)),
    puedeParticipar(OtroCantante, Conciento).

% Conocido directo
conocido(Cantante, OtroCantante) :-
    conoce(Cantante, OtroCantante).

%Conocido indirecto
conocido(Cantante, OtroCantante) :-
    conoce(Cantante, UnCantante),
    conoce(UnCantante, OtroCantante).

% 5
% Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, 
% explique los cambios que habría que realizar para que siga todo funcionando. ¿Qué conceptos facilitaron 
% dicha implementación?

% El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar 
% un tratamiento en particular a cada uno de los conciertos en la cabeza de la cláusula.