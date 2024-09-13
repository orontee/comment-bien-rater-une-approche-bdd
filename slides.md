---
title: Comment bien rater une approche BDD
titleTemplate: '%s - Sud-ouest Days'
layout: cover
background: 20230225_0023.webp
download: true
highlighter: shiki
---

# Comment bien rater une approche
#  *Behavior Driven Development*

Matthias Meulien - Sud-ouest Days - 17 mars 2023

---

# Quésaco ?
Behavior Driven Development

Suites logiques

<div class="text-2xl" style="letter-spacing: 5px;">
    <span v-click>2</span> <span v-click>3</span> <span v-click>5</span> <span v-click>7</span> <span v-click style="letter-spacing: 0;">11</span> <span v-click style="letter-spacing: 0;">13</span> <span v-click style="letter-spacing: 0;">17</span> <span v-click style="letter-spacing: 0;">19</span> <span v-click style="letter-spacing: 0;">23</span> <span v-click style="letter-spacing: 0;">29</span> <span v-click style="letter-spacing: 0;">31</span> <span v-click style="letter-spacing: 0;">37</span> <span v-click style="letter-spacing: 0;">41</span> <span v-click style="letter-spacing: 0;">43</span> <span v-click style="letter-spacing: 0;"><mdi-question-mark class="text-red-400"/></span> <span v-click style="letter-spacing: normal;"><b>47</b></span>
</div>

<div v-click>

Observation : on peut essayer de s'appuyer sur des <b>exemples
concrets</b> pour formaliser un comportement

</div>

<!--

Traduction : programmation pilotée par le comportement

Expérience de pensée.

Le 15ème nombre premier.

Avec des exemples concrets pour formaliser un comportement.

Relever :

- le point de vue du développeur (crible, implémentation)

- du PO (critères d'acceptation)

- du commercial 😄

-->

---

# Quésaco ?
Behavior Driven Development

Introducing BDD, <b>Dan North</b>, <i>Better Software Magazine Article</i>, 2006

<div v-click>En s'appuyant sur des <b>exemples concrets</b>, un
<b>language polyvalent</b> pourrait permettre de</div>

<v-clicks>

- Décrire le comportement attendu d'un système

- Exprimer les critères d'acceptation d'une implémentation

</v-clicks>

<div v-click>Retombées attendues</div>

<v-clicks>

- Faciliter la collaboration

- Constituer une documentation

- Automatisation de la vérification des critères d'acceptation

</v-clicks>

<!--

Faire le lien avec l'expérience de pensée précédente.

L'approche BDD n'implique pas :

- l'automatisation systématique de la vérification des critères
d'acceptation

- l'utilisation d'un framework donné.

-->

---

# Mise en œuvre & outillage
Language

<div v-click>
Gherkin
</div>

<div v-click>

```gherkin
# Example adapted from https://cucumber.io
@tag
Feature: Eating too many cucumbers may not be good for you

  Eating too much of anything may not be good for you

  Scenario: Eating too much is a problem
    Given Alice is hungry
    When she eats 4 cucumbers
    Then she should be "sick"

  Scenario Outline: Eating a few is no problem
    Given Alice is hungry
    And Alice feels good
    When she eats <number> cucumbers
    Then she should feel <feeling>

    | number | feeling |
    | 2      | good    |
    | 3      | full    |

```

</div>

<!--

Les "cornichons" en anglais.

Language non technique

Quelques mots clés (Given, When, Then)

Indentation

Tag, outline, background

Si on automatise la vérification des critères d'acceptation, le code
est séparé des critères.

Utiliser Gherkin n'est pas une obligation !

-->

---

# Mise en œuvre & outillage
Quadriciels

<v-clicks>

- [Cucumber](https://cucumber.io/)

  Basée sur Gherkin, automatise la vérification des critères
  d'acceptation, multi-language, bien plus qu'une bibliothèque : un
  écosystème (extension pour Jira, éditeur, etc.)

- [behave](https://behave.readthedocs.io/en/stable/)

  Basée sur Gherkin, automatise la vérification des critères
  d'acceptation, Python, pas hyper dynamique mais très bien documentée
  et stable

- [RSpec](https://rspec.info/)

  Orientée Ruby, bibliothèque historique, n'utilise pas Gherkin,
  implémentation des critères d'acceptation concomitants avec leur
  description

</v-clicks>

---
layout: two-cols
---

<template v-slot:default>

# Bike store
Contexte

L'API HTTP d'une boutique en ligne de vente de vélo

</template>

<template v-slot:right>

<div class="container items-center">
<img src="/bikestore-system-landscape.svg" class="self-center" style="width: 80%;" />
</div>

</template>
<!-- 

Cas d'une API HTTP qui sert à construire un site de vente de vélos

-->


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
clicks: 4
---

# Bike store
Exemple d'automatisation des critères d'acceptation

```gherkin {none|1|1,2|1,3|1,4|all}
  Scénario: Cas d'une marque en stock
    Étant donné qu'un vélo de marque "Motobécane" est en stock
    Quand un utilisateur recherche les vélos de marque "Motobécane"
    Alors la liste récupérée devrait "contenir le vélo"
```

<v-click at="1">
```python
@given("qu'un vélo de marque {brand} est en stock")
def step(ctx: Context, brand: str) -> None:
    bike_desc = ctx.docs[brand]
    ctx.current_bike_doc = ctx.db_client.replace_one(bike_desc, upsert=True)
```
</v-click>

<v-click at="2">
```python
@when("un utilisateur recherche les vélos de marque {brand}")
def step(ctx: Context, brand: str) -> None:
    url = "/bikes/find-by-brand"
    ctx.resp = ctx.http_client.get(url, params={"brand": brand})
```
</v-click>

<v-click at="3">
```python
@then("la liste récupérée devrait {expected_state}")
def step(ctx: Context, expected_state: str) -> None:
    assert("resp" in ctx and ctx.resp.status = 200)
    if expected_state == "être vide":
        assert(len(ctx.resp.data) == 0)
    elif expected_state == "contenir le vélo":
        assert("current_bike_doc" in ctx and ctx.current_bike_doc.id in [d.id for d in ctx.resp.data])
```
</v-click>

<!-- 

À chaque étape du scénario on fait correspondre une fonction.
-->

---

# Bike store
Interlude : le PO enrichit la spécification

<div v-click>
```gherkin
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

```gherkin {13-16|4,14|5,10,15|11,16}
Fonctionnalité: Recherche de vélo par marque

  Scénario: Cas d'une marque en stock
    Étant donné qu'un vélo de marque "Motobécane" est en stock
    Quand un utilisateur recherche les vélos de marque "Motobécane"
    Alors la liste récupérée devrait "contenir le vélo"

  Scénario: Cas d'une marque hors stock
    Étant donné que le stock ne contient pas de vélo de marque "Triban"
    Quand un utilisateur recherche les vélos de marque "Triban"
    Alors la liste récupérée devrait "être vide"

  Scénario: La recherche est sensible à la casse
    Étant donné qu'un vélo de marque "Motobécane" est en stock
    Quand un utilisateur recherche les vélos de marque "motobécane"
    Alors la liste récupérée devrait "être vide"
```

---

# Retour sur Mise en œuvre & outillage
Quadriciels

[RSpec est documenté en Gherkin, les exemples de la doc sont
exécutables
!](https://github.com/rspec/rspec-core/blob/main/features/)

[Documentation correspondant au Gherkin
suivant](https://rspec.info/features/3-12/rspec-core/command-line/randomization/)

<div style="overflow-y: scroll; display: inline-block; height: 75%;">

```gherkin
Feature: `--tag` option

  Use the `--tag` (or `-t`) option to run examples that match a specified tag.
  The tag can be a simple `name` or a `name:value` pair.

  If a simple `name` is supplied, only examples with `:name => true` will run.
  If a `name:value` pair is given, examples with `name => value` will run,
  where `value` is always a string. In both cases, `name` is converted to a symbol.

  Tags can also be used to exclude examples by adding a `~` before the tag. For
  example, `~tag` will exclude all examples marked with `:tag => true` and
  `~tag:value` will exclude all examples marked with `:tag => value`.

  Filtering by tag uses a hash internally, which means that you can't specify
  multiple filters for the same key. For instance, if you try to exclude
  `:name => 'foo'` and `:name => 'bar'`, you will only end up excluding
  `:name => 'bar'`.

  To be compatible with the Cucumber syntax, tags can optionally start with an
  `@` symbol, which will be ignored as part of the tag, e.g. `--tag @focus` is
  treated the same as `--tag focus` and is expanded to `:focus => true`.

  Background:
    Given a file named "tagged_spec.rb" with:
      """ruby
      RSpec.describe "group with tagged specs" do
        it "example I'm working now", :focus => true do; end
        it "special example with string", :type => 'special' do; end
        it "special example with symbol", :type => :special do; end
        it "slow example", :skip => true do; end
        it "ordinary example", :speed => 'slow' do; end
        it "untagged example" do; end
      end
      """

  Scenario: Filter examples with non-existent tag
    When I run `rspec . --tag mytag`
    Then the process should succeed even though no examples were run

  Scenario: Filter examples with a simple tag
    When I run `rspec . --tag focus`
    Then the output should contain "include {:focus=>true}"
    And the examples should all pass

  Scenario: Filter examples with a simple tag and @
    When I run `rspec . --tag @focus`
    Then the output should contain "include {:focus=>true}"
    Then the examples should all pass

  Scenario: Filter examples with a `name:value` tag
    When I run `rspec . --tag type:special`
    Then the output should contain:
      """
      include {:type=>"special"}
      """
    And the output should contain "2 examples"
    And the examples should all pass

  Scenario: Filter examples with a `name:value` tag and @
    When I run `rspec . --tag @type:special`
    Then the output should contain:
      """
      include {:type=>"special"}
      """
    And the examples should all pass

  Scenario: Exclude examples with a simple tag
    When I run `rspec . --tag ~skip`
    Then the output should contain "exclude {:skip=>true}"
    Then the examples should all pass

  Scenario: Exclude examples with a simple tag and @
    When I run `rspec . --tag ~@skip`
    Then the output should contain "exclude {:skip=>true}"
    Then the examples should all pass

  Scenario: Exclude examples with a `name:value` tag
    When I run `rspec . --tag ~speed:slow`
    Then the output should contain:
      """
      exclude {:speed=>"slow"}
      """
    Then the examples should all pass

  Scenario: Exclude examples with a `name:value` tag and @
    When I run `rspec . --tag ~@speed:slow`
    Then the output should contain:
      """
      exclude {:speed=>"slow"}
      """
    Then the examples should all pass

  Scenario: Filter examples with a simple tag, exclude examples with another tag
    When I run `rspec . --tag focus --tag ~skip`
    Then the output should contain "include {:focus=>true}"
    And the output should contain "exclude {:skip=>true}"
    And the examples should all pass

  Scenario: Exclude examples with multiple tags
    When I run `rspec . --tag ~skip --tag ~speed:slow`
    Then the output should contain one of the following:
      | exclude {:skip=>true, :speed=>"slow"} |
      | exclude {:speed=>"slow", :skip=>true} |
    Then the examples should all pass
```

</div>

<!--

Exemple pris de  https://github.com/rspec/rspec-core/blob/main/features/command_line/randomization.feature

-->

---

# Ecueils à éviter

<div v-click>

- Se tromper de language ou exposer des choix d'implémentation

```gherkin
Fonctionnalité: Recherche de vélo par marque

  Scénario: Cas d'une marque en stock
    Étant donné que la base de données contient le document
      """
      {"id": 36, "brand": "Motobécane",
       "color": "red", "size": 60, "status": "sold",
       "acquisition_date": "2019-12-15T22:33:01Z"}
      """
    Quand on requête l'URL "/bikes/find-by-brand" avec la méthode "GET" et la query string "?brand=Motobécane"
    Alors le statut de la réponse est "200"
    Et le JSON reçu est une liste qui contient un élément avec l'identifiant "36"
```

</div>

<v-clicks at="2">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Collaboration impossible, perte de l'aspect documentation</b></div>

</v-clicks>

<v-clicks at="3">

<div style="margin-top: 1em;">

- S'imposer de ne mettre qu'un scénario par fonctionnalité

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Perte de l'aspect documentation</b></div>

</div>

</v-clicks>

<v-clicks at="4">

<div style="margin-top: 1em;">

- S'imposer d'aller systématiquement jusqu'à l'automatisation

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Perte de l'aspect documentation</b></div>

</div>

</v-clicks>

<!--

Écrire des Gherkin et utiliser un framework comme Cucumber ne
suffisent pas pour être dans une approche BDD

Attention, recommandations à ne pas prendre au pied de la lettre et à
adapter au contexte

-->


---

# Ecueils à éviter

- Manquer de rigueur dans la formulation des critères d'acceptation

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

<v-clicks at="2">

<div style="margin-top: 1em;">

- Écrire à la fois des Gherkin pour tester <b>et</b> des critères
  d'acceptation dans un autre formalisme

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Travail en double ?</b></div>

</div>

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

<v-clicks at="2">

<div style="margin-top: 1em;">

- Bouchonner plutôt que peupler une base de données

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Fragile ! Et couplage entre instanciation des étapes et bouchons : impossible de réutiliser les étapes</b></div>

</div>

</v-clicks>

<!--

Car les bouchons sont généralement spécifiques à des paramètres
précis, donc sont fortement couplés à une instanciation des étapes : on
perd la réutilisabilité

-->

---

# Ecueils à éviter

- Mélanger les responsabilités des étapes

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

<v-clicks at="1">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Fragile ! Pas réutilisable…</b></div>

</v-clicks>

<v-clicks at="2">

<div style="margin-top: 1em;">

- Faire référence aux scénarios dans les implémentations

<div><mdi-hand-pointing-right class="text-red-400"/> <b>Fragile !</b></div>

</div>

</v-clicks>

---

# Ecueils à éviter

- S'imposer un framework BDD quand on ne veut pas faire plus que :

```sh
nvm install --lts
npm install --save-dev jest axios
```

```javascript
const axios = require('axios');

it('is possible to search bikes by brand', async () => {
  const response = await axios.get({url: '/bikes/find-by-brand?brand=LaBicycletteParfaite'});

  expect(response.status).toBe(200);
  expect(response.data).toBe(Array);
});
```


<v-clicks at="1">

<div><mdi-hand-pointing-right class="text-red-400"/> <b>L'approche BDD est plus coûteuse !</b></div>

<h3 style="margin-top: 2em; text-align: center;">L'approche BDD prend
tout son sens avec des systèmes complexes, à états. Un unique service
<i>stateless</i> n'est probablement pas la bonne cible.</h3>

</v-clicks>

<!-- Dans le cas d'un service stateless, les étapes deviennent des
paraphrases de l'API ou de la mise en place du contexte. -->

---

# Conclusion

<v-clicks>

- Essayez, ça peut réussir !

- ... mais être vigilant

- ... et ne pas perdre de vue les intérêts

</v-clicks>

---

# Références


* [Introducing BDD, Dan North, 2006](https://dannorth.net/introducing-bdd/)

* [Programmation pilotée par le comportement](https://fr.wikipedia.org/wiki/Programmation_pilot%C3%A9e_par_le_comportement)

* Le Concombre masqué contre le Grand Patatoseur, Nikita Mandryka, Dupuis, 1992

<img src="/URL.png" class="h-xs w-xs" />
---
layout: center
---

<img src="/cucumber.jpg" class="h-sm w-sm shadow" />
