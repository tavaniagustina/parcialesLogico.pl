herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 1
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% 2
satisfaceNecesidad(Persona, Herramienta) :-
    tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(PotenciaNecesaria)) :-
    tiene(Persona, aspiradora(Potencia)),
    between(0, Potencia, PotenciaNecesaria).    

% 3
puedeHacerTarea(Persona, Tarea) :-
    tiene(Persona, varitaDeNeutrones),
    herramientasRequeridas(Tarea, _).

puedeHacerTarea(Persona, Tarea) :-
    tiene(Persona, _),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceNecesidad(Persona, Herramienta)).

% 4
%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

valorACobrar(Cliente, ValorTotal) :-
    tareaPedida(_, Cliente, _),
    findall(Valor, valorUnaTarea(Cliente, _, Valor), Valores),
    sumlist(Valores, ValorTotal).

valorUnaTarea(Cliente, Tarea, Valor) :-
    tareaPedida(Tarea, Cliente, MetrosCuadrados),
    precio(Tarea, PrecioPorMetroCuadrado),
    Valor is MetrosCuadrados * PrecioPorMetroCuadrado.

% 5
aceptaPedido(Cliente, Persona) :-
    puedeHacerTodasLasTareas(Cliente, Persona),
    dispuestoAHacer(Cliente, Persona).

puedeHacerTodasLasTareas(Cliente, Persona) :-
    tiene(Persona, _),
    tareaPedida(_, Cliente, _),
    forall(tareaPedida(Tarea, Cliente, _), puedeHacerTarea(Persona, Tarea)).

dispuestoAHacer(Cliente, ray) :-
    not(tareaPedida(limpiarTecho, Cliente, _)).

dispuestoAHacer(Cliente, winston) :-
    valorACobrar(Cliente, ValorTotal),
    ValorTotal > 500.

dispuestoAHacer(Cliente, egon) :-
    tareaPedida(Tarea, Cliente, _),
    not(tareaCompleja(Tarea)).

dispuestoAHacer(_, peter).

tareaCompleja(limpiarTecho).

tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cuantas),
    Cuantas > 2.