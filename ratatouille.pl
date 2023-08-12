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
    trabajaEn(Restaurante, _),
    not(viveEn(Restaurante, _)).

% 2
chef(Chef, Restaurante) :-
    trabajaEn(Restaurante, Chef),
    cocina(Chef, _, _).

% 3
chefcito(Rata) :-
    viveEn(Restaurante, Rata),
    trabajaEn(Restaurante, linguini).

% 4
cocinaBien(remy, Plato) :-
    plato(Plato, _).

cocinaBien(Chef, Plato) :-
    cocina(Chef, Plato, Experiencia),
    Experiencia > 7.

% 5
encargadoDe(Chef, Plato, Restaurante) :-
    cocinaEn(Chef, Plato, Restaurante, MayorExperiencia),
    forall(cocinaEn(Chef, Plato, Restaurante, Experiencia), MayorExperiencia >= Experiencia).
  
cocinaEn(Chef, Plato, Restaurante, Experiencia) :-
    chef(Chef, Restaurante),
    cocina(Chef, Plato, Experiencia).

% 6
saludable(Plato) :-
    plato(Plato, Tipo),
    caloriasPorPlato(Tipo, Calorias),
    Calorias < 75.

caloriasPorPlato(postre(Calorias), Calorias).

caloriasPorPlato(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

caloriasPorPlato(principal(Guarnicion, Minutos), Calorias) :-
    caloriasPorPlato(Guarnicion, CaloriasGuarnicion),
    CaloriasCoccion is Minutos * 5,
    Calorias is CaloriasGuarnicion + CaloriasCoccion.

caloriasPorPlato(papasFritas, 50).
caloriasPorPlato(pure, 20).
caloriasPorPlato(ensalada, 0).

% 7
criticaPositiva(Restaurante, Critico) :-
    inspeccionSatisfactoria(Restaurante),
    reseniaCritico(Restaurante, Critico).

reseniaCritico(Restaurante, antonEgo) :-
    forall(chef(Chef, Restaurante), cocinaBien(Chef, ratatouille)).  

reseniaCritico(Restaurante, christophe) :-
    findall(Chef, chef(Chef, Restaurante), Chefs),
    length(Chefs, Cantidad),
    Cantidad > 3.    

reseniaCritico(Restaurante, cormillot) :-
    todosPlatosSaludables(Restaurante),
    todosTienenZanahoria(Restaurante).

todosPlatosSaludables(Restaurante) :-
    forall(cocinaEn(_, Plato, Restaurante, _), saludable(Plato)).    

todosTienenZanahoria(Restaurante) :-
    forall(entradaDe(Ingredientes, Restaurante), member(zanahoria, Ingredientes)).

entradaDe(Ingredientes, Restaurante) :-
    cocinaEn(_, Plato, Restaurante, _),
    plato(Plato, entrada(Ingredientes)).