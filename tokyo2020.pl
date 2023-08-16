% 1
% atleta(nombre, edad, país, disciplina).
atleta(dalilahMuhammad, 33, estadosUnidos, natacion400MetrosFemenino).
atleta(pareto, 44, argentina, judo).
atleta(tomas, 21, argentina, futbol).
atleta(alberto, 20, argentina, voleyMasculino).
atleta(roberto,22, argentina, voleyMasculino).
atleta(micole, 17, suiza, natacion400MetrosFemenino).
atleta(micole, 16, suiza, carrera100MetrosLlanosFemenino).
atleta(martin, 19, corea, ninguna).
atleta(luisa, 23, argentina, hockeyFemenino).
atleta(romina, 25, holanda, hockeyFemenino).

% disciplina(tipo, disciplina).
disciplina(equipo, voleyMasculino).
disciplina(individual, judo).
disciplina(equipo, futbol).
disciplina(individual, natacion400MetrosFemenino).
disciplina(individual, carrera100MetrosLlanosFemenino).
disciplina(individual, carrera400MetrosConVallasFemenino).
disciplina(individual, son100MetrosEspaldaMasculino).
disciplina(equipo, hockeyFemenino).

%  medalla(medalla, pais/persona, disciplina).
medalla(bronce, argentina, voleyMasculino).
medalla(plata, micole, carrera100MetrosLlanosFemenino).
medalla(plata, dalilahMuhammad, carrera400MetrosConVallasFemenino).
medalla(plata, argentina, hockeyFemenino).
medalla(oro, holanda, hockeyFemenino).

% evento(disciplina, ronda, pais/Personas)
evento(hockeyFemenino, final, argentina).
evento(hockeyFemenino, final, holanda).
evento(carrera100MetrosEspaldaMasculino, ronda2, pepito).
evento(carrera100MetrosEspaldaMasculino, ronda2, lautaro).
evento(carrera100MetrosEspaldaMasculino, ronda2, cris).
evento(carrera100MetrosEspaldaMasculino, ronda2, messi).
evento(carrera100MetrosEspaldaMasculino, ronda2, massa).
evento(carrera100MetrosEspaldaMasculino, ronda2, milei).
evento(carrera100MetrosEspaldaMasculino, ronda2, cristina).
evento(carrera100MetrosEspaldaMasculino, ronda2, macri).
evento(futbol, faseDeGrupos, argentina).

% 2
vinoAPasear(Atleta) :-
    atleta(Atleta, _, _, ninguna).

% 3
medallasDelPais(Disciplina, Medallas, Pais) :-
    atleta(_, _, Pais, Disciplina),
    findall(Medalla, medallaDelPais(Medalla, Pais, Disciplina), Medallas).

medallaDelPais(Medalla, Pais, Disciplina) :-
    atleta(Atleta, _, Pais, Disciplina),
    medalla(Medalla, Atleta, Disciplina).

medallaDelPais(Medalla, Pais, Disciplina) :-
    medalla(Medalla, Atleta, Disciplina),
    not(atleta(Atleta, _, Pais, Disciplina)).

% 4
participoEn(Ronda, Disciplina, Atleta) :-
    evento(Disciplina, Ronda, Atleta).

participoEn(Ronda, Disciplina, Atleta) :-
    atleta(Atleta, _, Pais, Disciplina),
    evento(Disciplina, Ronda, Pais).

% 5
dominio(Pais, Disciplina) :-
    medallasDelPais(Disciplina, oro, Pais),
    medallasDelPais(Disciplina, bronce, Pais),
    medallasDelPais(Disciplina, plata, Pais).

% 6
medallaRapida(Disciplina) :-
    evento(Disciplina, Ronda1, Pais),
    forall(evento(Disciplina, Ronda, Pais), mismaRonda(Ronda1, Ronda)).

mismaRonda(Ronda, Ronda).

% 7
noEsElFuerte(Pais, Disciplina) :-
    disciplina(_, Disciplina),
    noParticipo(Pais, Disciplina).

noEsElFuerte(Pais, Disciplina) :-
    disciplina(_, Disciplina),
    soloLlegoAPrimeraRonda(Pais, Disciplina).

noParticipo(Pais, Disciplina) :-
    atleta(_, _, Pais, Disciplina),
    not(atleta(_, _, Pais, Disciplina)).

soloLlegoAPrimeraRonda(Pais, Disciplina) :-
    atleta(_, _, Pais, Disciplina),
    forall(atleta(Atleta, _, Pais, Disciplina), evento(Disciplina, ronda1, Atleta)),
    forall(atleta(Atleta, _, Pais, Disciplina), evento(Disciplina, faseDeGrupos, Atleta)).

% 8
medallasEfectivas(Pais, SumaDeMedallas) :-
    atleta(_, _, Pais, _),
    findall(Valor, valorMedallaDelPais(Pais, _, Valor), Valores),
    sumlist(Valores, SumaDeMedallas).
    
valorMedallaDelPais(Pais, Disciplina, Valor) :-
    disciplina(_, Disciplina),
    medallaDelPais(Pais, Disciplina, Medalla),
    valorMedalla(Medalla, Valor).

valorMedalla(bronce, 1).
valorMedalla(plata, 2).
valorMedalla(oro, 3).  

%  9
