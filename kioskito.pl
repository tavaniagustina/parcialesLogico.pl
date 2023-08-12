% Punto 1
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

% 1
atiende(vale, Dia, HoraDeInicio, HoraDeFinalizacion) :-
    atiende(dodain, Dia, HoraDeInicio, HoraDeFinalizacion).

atiende(vale, Dia, HoraDeInicio, HoraDeFinalizacion) :-
    atiende(juanC, Dia, HoraDeInicio, HoraDeFinalizacion).

% Por el concepto de universo cerrado, lo que no es verdadero se considera falso, por lo q no hace 
% falta agregarlo a la base de conocimiento

% 2
quienAtiende(Dia, Hora, Persona) :-
    atiende(Persona, Dia, HoraDeInicio, HoraDeFinalizacion),
    between(HoraDeInicio, HoraDeFinalizacion, Hora).

% 3
foreverAlone(Persona, Dia, Hora) :-
    quienAtiende(Dia, Hora, Persona),
    not((quienAtiende(Dia, Hora, OtraPersona), Persona \= OtraPersona)).

% 4
posibilidadDeAtencion(Dia, Personas) :-
    atiende(Persona, _, _, _),
    findall(Persona, quienAtiende(Dia, _, Persona), PersonasPosibles),
    combinar(PersonasPosibles, Personas).

combinar([], []).

combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
    combinar(PersonasPosibles, Personas).

combinar([_|PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).   

% 5
venta(dodain, fecha(10, 08), [golosinas(1200), cigarrillos(jockey), golosinas(10)]).
venta(dodain, fecha(12, 08), [bebida(true, 8), bebida(false, 1), golosinas(10)]).
venta(martu, fecha(12, 08), [golosinas(100), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 08), [golosinas(600)]).
venta(lucas, fecha(18, 08), [bebida(false, 2), cigarrillos(derby)]).

esSuertuda(Persona) :-
    venta(Persona, _, _),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).
    
ventaImportante(golosinas(Precio)) :-
    Precio > 100.

ventaImportante(cigarrillos(Marcas)) :-
    length(Marcas, Cantidad),
    Cantidad > 2.

ventaImportante(bebida(true, _)).

ventaImportante(bebida(_, Cantidad)) :-
    Cantidad > 5.