%persona(Nombre, Edad)
persona(laura, 24). 
persona(federico, 31).
persona(maria, 23).
persona(jacobo, 45). 
persona(enrique, 49).
persona(andrea, 38).
persona(gabriela, 4).
persona(gonzalo, 23). 
persona(alejo, 20).
persona(ricardo, 39).
persona(andres, 11).
persona(ana, 7). 
persona(juana, 15).

%quiere(Quién, Quiere)
quiere(andres, juguete(maxSteel, 150)). 
quiere(andres, bloques([piezal, plezat, cubo, plezachata])). 
quiere(maria, bloques([plezat, piezaT])).
quiere(alejo, bloques([plezat])).
quiere(juana, juguete(barble, 175)).
quiere(enrique, abrazo). 
quiere(gabriela, juguete(gabeneltor2000, 5000)).
quiere(federico, abrazo).
quiere(gonzalo, abrazo).
quiere(laura, abrazo).

%presupuesto(Quien, Presupuesto).
presupuesto(jacobo, 20).
presupuesto(enrique, 2311).
presupuesto(ricardo, 154).
presupuesto(andrea, 100).
presupuesto(laura, 2000).

%accion(Quien, Hizo)
accion(andres, travesura(3)).
accion(andres, ayudar(ana)).
accion(ana, golpear(andres)).
accion(ena, travesura(1)).
accion(maria, ayudar(federico)).
accion(maria, favor(juana)).
accion(alejo, travesura(4)).
accion(juana, favor(maria)). 
accion(federico, golpear(enrique)).
accion(gonzalo, golpear(alejo)).

%padre(Padre o Madre, Hijo o Hija).
padre(jacobo, ana).
padre(jacobo, juana).
padre(enrique, federico).
padre(ricardo, maria).
padre(andrea, andres). 
padre(laura, gabriela).

% 1
buenaAccion(favor(Persona)) :-
    persona(Persona, _). 

buenaAccion(ayudar(Persona)) :-
    persona(Persona, _). 

buenaAccion(travesura(Nivel)) :-
    Nivel < 3.

% 2
sePortoBien(Persona) :-
    persona(Persona, _),
    forall(accion(Persona, Accion), buenaAccion(Accion)).

% 3
malcriador(Padre) :-
    padre(Padre, Hijo),
    accion(Hijo, Accion),
    not(buenaAccion(Accion)).

malcriador(Padre) :-
    padre(Padre, Hijo),
    not(creeEnPapaNoel(Hijo)).

creeEnPapaNoel(federico).

creeEnPapaNoel(Hijo) :-
    persona(Hijo, Edad),
    Edad < 13.

% 4
puedeCostear(Padre, Hijo) :-
    padre(Padre, Hijo),
    presupuesto(Padre, Presupuesto),
    quiere(Hijo, Regalo),
    findall(Costo, costoRegalo(Regalo, Costo), Costos),
    sumlist(Costos, CostoTotal),
    Presupuesto >= CostoTotal.

costoRegalo(juguete(_, Costo), Costo).

costoRegalo(bloques(ListaDeBloques), Costo) :-
    Costo is ListaDeBloques * 3.

costoRegalo(abrazo, 0).

% 5
regaloCandidatoPara(Regalo, Persona) :-
    quiere(Persona, Regalo),
    sePortoBien(Persona),
    padre(Padre, Persona),
    puedePagarlo(Regalo, Padre).

puedePagarlo(Regalo, Padre) :-
    costoRegalo(Regalo, Costo),
    presupuesto(Padre, Presupuesto),
    Presupuesto >= Costo.

% 6
regalosQueRecibe(Persona, Regalos) :-
    padre(Padre, Persona),
    puedeCostear(Padre, Persona),
    findall(Regalo, quiere(Persona, Regalo), Regalos).

regalosQueRecibe(Persona, Regalos) :-
    padre(Padre, Persona),
    not(puedeCostear(Padre, Persona)),
    chicoDePadresPobresRecibe(Persona, Regalos).

chicoDePadresPobresRecibe(Persona, [mediasGris, mediasBlancas]) :-
    sePortoBien(Persona).

chicoDePadresPobresRecibe(Persona, [carbon]) :-
    accion(Persona, Accion1),
    accion(Persona, Accion2),
    not(buenaAccion(Accion1)),
    not(buenaAccion(Accion2)),
    Accion1 \= Accion2.

% 7
sugarDaddy(Padre) :-
    padre(Padre, _),
    forall(padre(Padre, Hijo), quiereRegalosCarosOQueValenLaPena(Hijo)).

quiereRegalosCarosOQueValenLaPena(Hijo) :-
    forall(quiere(Hijo, Regalo), esCaro(Regalo)).

quiereRegalosCarosOQueValenLaPena(Hijo) :-
    forall(quiere(Hijo, Regalo), valeLaPena(Regalo)).

esCaro(juguete(_, Precio)) :-
    Precio > 500.

valeLaPena(juguete(Tipo, _)) :-
    buzzOWoody(Tipo).

valeLaPena(bloques(Piezas)) :-
    member(cubo, Piezas).

buzzOWoody(buzz).
buzzOWoody(woody).