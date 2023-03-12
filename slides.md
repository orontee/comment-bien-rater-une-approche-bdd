---
title: Comment bien rater une approche BDD
titleTemplate: '%s - Sud-ouest Days'
layout: cover
background: 'public/20230225_0023.jpg'
download: true
---

# Comment bien rater une approche
#  *Behavior Driven Development*

Matthias Meulien - Sud-ouest Days - 17 mars 2023

---

# Quésaco ?
Behavior Driven Development

Suites logiques

<div v-click>
2 3 5 7 11 13 17 19 23 29 31 37 41 43 ?
</div>

<!-- Traduction : programmation pilotée par le comportement -->
<!-- Analogie -->
<!-- 45, pointure de pied ; 48, age ; 47 ! -->

---

# Quésaco ?
Behavior Driven Development

Suites logiques

2 3 5 7 11 13 17 19 23 29 31 37 41 43 **47**

<!-- La suite des nombres premiers, point de vue du commercial, du PO
et du développeur -->

<div v-click>Observation : on peut essayer de s'appuyer sur des
<b>exemples concrets</b> pour formaliser un comportement</div>

---

# Quésaco ?
Behavior Driven Development

Introducing BDD, <b>Dan North</b>, <i>Better Software Magazine Article</i>, 2006

<div v-click>Un <b>language polyvalent</b> doit permettre de :</div>

<v-clicks>

- décrire le comportement attendu

- exprimer les critères d'acceptation

</v-clicks>

<div v-click>Intérêts</div>

<v-clicks>

- Collaboration

- Documentation

- Automatisation des tests

</v-clicks>

---

# Mise en œuvre & outillage

* Language : Gherkin

* Bibliothèques : Cucumber, behave, etc.

* Rapports : Serenity

---

# Bike store
Contexte

<!-- graphe mermaid -->


---

# Bike store
Exemple de Gherkin

```gherkin {1-3|1-3,4|1-3,5|1-3,6|all}
Fonctionnalité: Recherche de vélo par marque

Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Motobécane"
Alors la liste récupérée devrait "contenir le vélo"

Scénario: Cas d'une marque hors stock
Étant donné que le stock ne contient pas de vélo de marque "Triban"
Quand un utilisateur recherche les vélos de marque "Triban"
Alors la liste récupérée devrait "être vide"
```

---

# Bike store
Exemple d'automatisation des critères d'acceptation

```gherkin
Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Motobécane"
Alors la liste récupérée devrait "contenir le vélo"
```

<v-clicks at="1">
<div>
```python
@given("qu'un vélo de marque {brand} est en stock")
def step(ctx: Context, brand: str) -> None:
    bike_desc = ctx.docs[brand]
    ctx.current_bike_doc = ctx.db_client.replace_one(bike_desc, upsert=True)
```
</div>
</v-clicks>

<v-clicks at="2">
<div>
```python
@when("un utilisateur recherche les vélos de marque {brand}")
def step(ctx: Context, brand: str) -> None:
    url = "/bikes/find-by-brand"
    ctx.resp = ctx.http_client.get(url, params={"brand": brand})
```
</div>
</v-clicks>

<v-clicks at="3">
<div>
```python
@then("la liste récupérée devrait {expected_state}")
def step(ctx: Context, expected_state: str) -> None:
    assert("resp" in ctx and ctx.resp.status = 200)
    if expected_state == "être vide": 
        assert(len(ctx.resp.data) == 0)
    elif expected_state == "contenir le vélo":
        assert("current_bike_doc" in ctx and ctx.current_bike_doc.id in [d.id for d in ctx.resp.data])
```
</div>
</v-clicks>


---

# Bike store
Interlude : le PO enrichit la spécification

<div v-click>
```gherkin {8-12}
Fonctionnalité: Recherche de vélo par marque

Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Motobécane"
Alors la liste récupérée devrait "contenir le vélo"

Scénario: Cas d'une marque hors stock
Étant donné que le stock ne contient pas de vélo de marque "Triban"
Et qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Triban"
Alors la liste récupérée devrait "être vide"
```
</div>

---

# Bike store
Interlude : le PO enrichit la spécification

```gherkin {14-17|4,10,15|5,11,16|12,17}
Fonctionnalité: Recherche de vélo par marque

Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Motobécane"
Alors la liste récupérée devrait "contenir le vélo"

Scénario: Cas d'une marque hors stock
Étant donné que le stock ne contient pas de vélo de marque "Triban"
Et qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Triban"
Alors la liste récupérée devrait "être vide"

Scénario: La recherche est sensible à la casse
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "motobécane"
Alors la liste récupérée devrait "être vide"
```

<!-- diapos sur tags et table ? -->

---

# Ecueils à éviter

<div v-click>

- Se tromper de language ou exposer des choix d'implémentation

```gherkin
Scénario: Cas d'une marque en stock
Étant donné que la base de données contient le document
    """"
    {"id": 36, "brand": "Motobécane", 
     "color": "red", "size": 60, "status": "sold",
     "acquisition_date": "2019-12-15T22:33:01Z"}
    """"
Quand on requête l'URL "/bikes/find-by-brand" avec la méthode "GET" et la query string "?brand=Motobécane"
Alors le statut de la réponse est "200"
Et le JSON reçu est une liste qui contient un élément avec l'identifiant "36"
```

</div>

<v-clicks at="2">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Collaboration impossible, perte de l'aspect documentation</b></div>

</v-clicks>

<!-- Écrire des Gherkin, utiliser un framework comme Cucumber ne
suffisent pas pour être dans une approche BDD -->

<v-clicks at="3">

<div style="margin-top: 1em;">

- S'imposer de ne mettre qu'un scénario par fonctionnalité

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Perte de l'aspect documentation</b></div>

</div>

</v-clicks>

<!-- Pour épater votre direction et faire grimper artificiellement le
nombre de tests réalisés -->

<v-clicks at="4">

<div style="margin-top: 1em;">

- S'imposer d'aller systématiquement jusqu'à l'automatisation

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Perte de l'aspect documentation</b></div>

</div>

</v-clicks>

---

# Ecueils à éviter

- Manquer de rigueur dans la formulation des Gherkin

```gherkin {all|5,10}
Fonctionnalité: Recherche de vélo par marque

Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque "Motobécane" est en stock
Quand un utilisateur recherche les vélos de marque "Motobécane"
Alors la liste récupérée devrait "contenir le vélo"

Scénario: Cas d'une marque hors stock
Étant donné que le stock ne contient pas de vélo de marque "Triban"
Quand l'utilisateur requête les vélos "Triban"
Alors la liste récupérée devrait "être vide"
```

<v-clicks at="1">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Impossible de réutiliser les implémentations des étapes entre scénarios</b></div>

</v-clicks>

---

# Ecueils à éviter

- Mal anticiper le niveau de généricité utile à la réutilisation

```gherkin {all|6,11}
Fonctionnalité: Recherche de vélo par marque

Scénario: Cas d'une marque en stock
Étant donné qu'un vélo de marque Motobécane est en stock
Quand un utilisateur recherche les vélos de marque Motobécane
Alors le vélo Motobécane devrait être trouvé

Scénario: Cas d'une marque hors stock
Étant donné que le stock ne contient aucun vélo de marque Triban
Quand un utilisateur recherche les vélos de marque Triban
Alors aucun vélo ne sera trouvé
```

<v-clicks at="1">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Impossible de réutiliser les implémentations des étapes entre scénarios</b></div>

</v-clicks>

<!-- Écrire des Gherkin, utiliser un framework comme Cucumber ne
suffisent pas pour être dans une approche BDD -->

---

# Ecueils à éviter

- Mélanger les responsabilité des étapes

```python
@given("qu'un vélo de marque {brand} est en stock")
def step(ctx: Context, brand: str) -> None:
    bike_desc = ctx.docs[brand]
    ctx.current_bike_desc = bike_desc

@when("un utilisateur recherche les vélos de marque {brand}")
def step(ctx: Context, brand: str) -> None:
    assert("current_bike_desc" in ctx)
    ctx.db_client.replace_one(ctx.current_bike_desc, upsert=True)

    ctx.current_bike_doc = ctx.db_client.replace_one(bike_desc, upsert=True)

    url = "/bikes/find-by-brand"
    ctx.resp = ctx.http_client.get(url, params={"brand": brand})
```

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Fragile !</b></div>

<v-clicks at="1">

<div style="margin-top: 1em;">

- Faire référence aux scénarios dans les implémentations

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Fragile !</b></div>

</div>

</v-clicks>

---

# Cas d'une API HTTP

<!-- Exemple de test avec jest -->

---

# Références


* [Introducing BDD, Dan North, 2006](https://dannorth.net/introducing-bdd/)

* [Programmation pilotée par le comportement](https://fr.wikipedia.org/wiki/Programmation_pilot%C3%A9e_par_le_comportement)

* Le Concombre masqué fait avancer les choses, Dupuis, 1992
