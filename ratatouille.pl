% viveEn(dónde viven, nombre rata)
viveEn(gusteaus, remy).
viveEn(bar,emile).
viveEn(jeSuis, django).

% cocina(nombre, qué platos saben cocinar, experiencia)
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

% quién trabaja en cada (restaurante, persona)
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

% platos del menú (entradas, platos principales, postres)
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).


% Punto 1
inspeccionSatisfactoria(Restaurante) :-
    trabajaEn(Restaurante, _),
    not(viveEn(Restaurante, _)).

% Punto 2
chef(Empleado, Restaurante) :-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).

% Punto 3
chefcito(Rata) :-
    viveEn(Restaurante, Rata),
    trabajaEn(Restaurante, linguini).

% Punto 4
cocinaBien(Empleado, Plato) :-
    cocina(Empleado, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, Plato) :-
    plato(Plato, _).

% Punto 5
encargadoDe(Encargado, Plato, Restaurante) :-
    cocinaEn(Encargado, Plato, Restaurante, ExperienciaMaxima),
    forall(cocinaEn(Encargado, Plato, Restaurante, UnaExperiencia), ExperienciaMaxima >= UnaExperiencia).

cocinaEn(Encargado, Plato, Restaurante, Experiencia) :-
    chef(Encargado, Restaurante),
    cocina(Encargado, Plato, Experiencia).

% Punto 6 
saludable(Plato) :-
    plato(Plato, Tipo),
    caloriasPara(Tipo, Calorias),
    Calorias < 75.

caloriasPara(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cuantos),
    Calorias is Cuantos * 15. 
    
caloriasPara(principal(Guarnicion, Minutos), Calorias) :-
    CaloriasCoccion is Minutos * 5,
    caloriasPara(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasCoccion + CaloriasGuarnicion.

caloriasPara(pure, 20).
caloriasPara(papasFirtas, 50).
caloriasPara(ensalada, 0).
caloriasPara(postre(Calorias), Calorias).

% Punto 7
criticaPositiva(Restaurante, Critico) :-
    inspeccionSatisfactoria(Restaurante),
    resenaPositiva(Restaurante, Critico).

resenaPositiva(Restaurante, antonEgo) :-    
    especialistaEn(ratatouille, Restaurante).

especialistaEn(Plato, Restaurante) :-
    forall(chef(Chef, Restaurante), cocinaBien(Chef, Plato)).
    
resenaPositiva(Restaurante, christophe) :-    
    findall(Chef, chef(Chef, Restaurante), Chefs),
    length(Chefs, Cuantos),
    Cuantos > 3.

resenaPositiva(Restaurante, cormillot) :-    
    todosLosPlatosSaludables(Restaurante),
    todosLosPlatosTieneZanahoria(Restaurante).

todosLosPlatosSaludables(Restaurante) :-
    forall(cocinaEn(_, Plato, Restaurante, _), saludable(Plato)).

todosLosPlatosTieneZanahoria(Restaurante) :-
    forall(entradasDe(Restaurante, Ingredientes), tieneZanahoria(Ingredientes)).

entradasDe(Restaurante, Ingredientes) :-
    plato(Plato, entrada(Ingredientes)),
    cocinaEn(_, Plato; Restaurante, _).
    
tieneZanahoria(Ingredientes) :-
    member(zanahoria, Ingredientes).    