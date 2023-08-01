% viveEn(dónde viven, nombre rata)
viveEn(gusteaus, remy).
viveEn(bar, emile).
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
    trabajaEn(Restaurante, _).  
    not(viveEn(Restaurante, _)).

% Punto 2
chef(Chef, Restaurante) :-
    trabajaEn(Restaurante, Chef),
    cocina(Chef, _, _).

% Punto 3
chefcito(Rata) :-
    trabajaEn(Restaurante, linguini),
    viveEn(Restaurante, Rata).

% Punto 4
cocinaBien(Chef, Plato) :-
    cocina(Chef, Plato, Experiencia),
    Experiencia >= 7.

cocinaBien(remy, Plato) :-
    plato(Plato, _).

% Punto 5
encargadoDe(Chef, Plato, Restaurante) :-
    cocinaEn(Chef, Plato, Restaurante, unaExperiencia),
    forall(cocinaEn(_, Plato, Restaurante, otraExperiencia), unaExperiencia >= otraExperiencia).

cocinaEn(Chef, Plato, Restaurante, Experiencia) :-
    chef(Chef, Restaurante),
    cocina(Chef, Plato, Experiencia).

% Punto 6 
esSaludable(Plato) :-
    plato(Plato, Tipo),
    caloriasPara(Tipo, Calorias),
    Calorias < 75.

caloriasPara(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.
    
caloriasPara(principal(Guarnicion, Minutos), Calorias) :-
    CaloriasMinutos is Minutos * 5,
    caloriasPara(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasMinutos + CaloriasGuarnicion.

caloriasPara(pure, 20).
caloriasPara(papasFritas, 20).
caloriasPara(ensalada, 0).

caloriasPara(postre(Calorias), Calorias).

% Punto 7
criticaPositiva(Restaurante, Critico) :-
    chef(_, Restaurante),
    inspeccionSatisfactoria(Restaurante),
    reseniaPositiva(Critico, Restaurante).

reseniaPositiva(antonEgo, Restaurante) :-
    forall(chef(Chef, Restaurante), cocinaBien(Chef, ratatouille)).

reseniaPositiva(christophe, Restaurante) :-
    findall(Chef, chef(Chef, Restaurante), Chefs),
    length(Chefs, Cauntos),
    Cauntos > 3.
    
reseniaPositiva(cormillot, Restaurante) :-
    todosPlatosSaludables(Restaurante),
    todasEntradasTienenZanahorias(Restaurante).

todosPlatosSaludables(Restaurante) :-
    forall(cocinaEn(_, Plato, Restaurante, _), esSaludable(Plato)).

todasEntradasTienenZanahorias(Restaurante) :-
    forall(entradaDe(Restaurante, Ingredientes), tieneZanahoria(Ingredientes)).

entradaDe(Restaurante, Ingredientes) :-
    cocinaEn(_, Plato, Restaurante, _),
    plato(Plato, entrada(Ingredientes)).

tieneZanahoria(Ingredientes) :-
    member(zanahoria, Ingredientes). 