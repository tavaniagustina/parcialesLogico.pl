% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

% 1
esUnAfano(UnJugador, OtroJugador) :-
    jugador(UnJugador, UnRating, _),
    jugador(OtroJugador, OtroRating, _),
    UnJugador \= OtroJugador,
    abs(UnRating - OtroRating) > 500.

% 2
esEfectivo(Tipo1, Tipo2) :-
    militar(Tipo1, _, Categoria1),
    militar(Tipo2, _, Categoria2),
    puedeGanarSegunCategoria(Categoria1, Categoria2).

esEfectivo(samurai, Tipo) :-
    militar(Tipo, _, unica),

puedeGanarSegunCategoria(caballeria, arqueria).
puedeGanarSegunCategoria(arqueria, infanteria).
puedeGanarSegunCategoria(infanteria, piquero).
puedeGanarSegunCategoria(piqueros, caballeria).

% 3
alarico(Jugador) :-
    tieneUnidadesDe(Jugador, infanteria).

% 4
leonidas(Jugador) :-
    tieneUnidadesDe(Jugador, piqueros).

tieneUnidadesDe(Jugador, Categoria) :-
    jugador(Jugador, _, _),
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad,_, Categoria)).

% 5
nomada(Jugador) :-
    jugador(Jugador, _, _),
    not(tieneAlgunEdificio(Jugador, casa)).

tieneAlgunEdificio(Jugador, TipoDeEdificio) :-
    tiene(Jugador, edificio(TipoDeEdificio, _)).

% 6
cuantoCuesta(Tipo, Costo) :-
    edificio(Tipo, Costo).

cuantoCuesta(Tipo, Costo) :-
    militar(Tipo, Costo, _).

cuantoCuesta(Tipo, costo(_, 50, _)) :-
    aldeano(Tipo, _).

cuantoCuesta(Tipo, costo(_, 100, _)) :-
    esCarretaOUrna(Tipo).

esCarretaOUrna(carreta).
esCarretaOUrna(urna).
        
% 7
produccion(Tipo, ProduccionPorMinuto) :-
    aldeano(Tipo, ProduccionPorMinuto).

produccion(Tipo, produce(0, 0, 32)) :-
    esCarretaOUrna(Tipo).

produccion(Tipo, produce(0, 0, Oro)) :-
    militar(Tipo, _, _),
    esDeTipo(Tipo, Oro).

esDeTipo(keshik, 10).
esDeTipo(_, 0).
    
% 8
produccionTotal(Jugador, Recurso, ProduccionTotalPorMinuto) :-
    tiene(Jugador, _),
    recursos(Recurso),
    findall(Produccion, loTieneYLoProduce(Jugador, Recurso, Produccion), Producciones),
    sum_list(Producciones, ProduccionTotalPorMinuto).

loTieneYLoProduce(Jugador, Recurso, Produccion) :-
    tiene(Jugador, unidad(Tipo, Cuantas)),
    produccion(Tipo, ProduccionTotal),
    produccionDelRecurso(Recurso, ProduccionTotal, ProduccionRecurso),
    Produccion is ProduccionRecurso + Cuantas.

produccionDelRecurso(madera, produce(Madera, _, _), Madera).
produccionDelRecurso(alimento, produce(_, Alimento, _), Alimento).
produccionDelRecurso(oro, produce(_, _, Oro), Oro).
  
recursos(madera).
recursos(alimento).
recursos(oro).

% 9
% estaPeleado(Nombre1, Nombre2) :-
%     not(esUnAfano(Nombre1, Nombre2)),
%     cantidadDeUnidades(Nombre1, Cantidad),
%     cantidadDeUnidades(Nombre2, Cantidad),
%     verProduccionSegun(Recurso, Nombre1, Nombre2).

% produccionesTotales(Nombre1, Nombre2, Produccion1, Produccion2):-

% 10
avanzaA(Jugador, Edad) :-
    jugador(Jugador, _, _),
    avanzarSegun(Jugador, Edad).

avanzarSegun(_, edadMedia).

avanzarSegun(Jugador, edadFeudal) :-
    tieneAlimento(Jugador, 500),
    tieneAlgunEdificio(Jugador, casa).

avanzarSegun(Jugador, edadDeLosCastillos) :-
    tieneAlimento(Jugador, 800),
    tieneOro(Jugador, 200),
    edificioDeEdadDeLosCastillos(EdificioDeEdadDeLosCastillos),
    tieneAlgunEdificio(Jugador, EdificioDeEdadDeLosCastillos).

avanzarSegun(Jugador, edadImperial) :-
    tieneAlimento(Jugador, 1000),
    tieneOro(Jugador, 800),
    edificioDeEdadImperial(EdificioDeEdadImperial),
    tieneAlgunEdificio(Jugador, EdificioDeEdadImperial).

tieneAlimento(Jugador, Cantidad) :-
    recursosPersona(Jugador, _, Alimento, _),
    Alimento > Cantidad.

tieneOro(Jugador, Cantidad) :-
    recursosPersona(Jugador, _, _, Oro),
    Oro > Cantidad.

recursosPersona(Jugador, Madera, Alimento, Oro) :-
    tiene(Jugador, recurso(Madera, Alimento, Oro)).

edificioDeEdadDeLosCastillos(herreria).
edificioDeEdadDeLosCastillos(establo).
edificioDeEdadDeLosCastillos(galeriaDeTiro).

edificioDeEdadImperial(castillo).
edificioDeEdadImperial(universidad).
