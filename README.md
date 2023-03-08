# Comment bien rater une approche BDD

«Comment bien rater une approche BDD» est une présentation technique
en français sur le *Behavior Driven Development*.

## À propos de la présentation

### Résumé

Le Behavior Driven Development (BDD) promet :

* de favoriser la collaboration entre développeurs, ingénieurs qualité
  et intervenants non techniques

* de réunir dans une même formulation comportement du système,
  critères d'acceptation et documentation

Bien entendu ces promesses ne reposent pas seulement sur l'utilisation
d'un framework de test orienté BDD ! On illustre de mauvais usages à
éviter pour ne pas ruiner les chouettes promesses du BDD.

### Déroulé

* 12 min. - Illustration de la démarche BDD sur un exemple concret

* 06 min. - Interlude : où le product owner enrichit la spécification
  (donc les tests !) de manière autonome

* 12 min. - Les écueils à éviter

### Références

* [Introducing BDD, Dan North, 2006](https://dannorth.net/introducing-bdd/)

* [Programmation pilotée par le comportement](https://fr.wikipedia.org/wiki/Programmation_pilot%C3%A9e_par_le_comportement)

* Le Concombre masqué contre le grand Patatoseur, Nikita Mandryka, Dupuis, 1992

## Diapositives

Les diapositives sont générées avec l'outil [slidev](https://sli.dev/)
; les sources se trouvent dans le fichier [slides.md](./slides.md).

Pour les modifier :
```
nvm use
npm install
npm run dev
```

Pour générer une version statique dans le répertoire `dist` :
```
npm run build
```
Les diapos sont publiées sur https://orontee.github.io/comment-bien-rater-une-approche-bdd/.

Pour mettre à jour le diagramme :
```
podman pull --quiet structurizr/cli:latest
podman run -it --rm -v $PWD:/usr/local/structurizr structurizr/cli export -workspace workspace.dsl -format dot
dot -Tsvg structurizr-system-landscape.dot -o public/bikestore-system-landscape.svg

```
