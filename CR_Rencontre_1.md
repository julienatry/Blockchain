# Compte rendu de première rencontre

**Groupe Blockchain**

*Chef de projet* : 
 - Rémy DUPEYROUX
 - 
*Autres membres* : 
 - Julien ATRY
 - Victor LEHERICHER
 - Tim FROLOV
 - Mikael VAZ MARTINS

*Encadrant attitré* :
 - Mr. ROGET

## Cahier des charges : 

Deux objectifs sont attendus au cours de ce projet.

### Une présentation au jury

Nous devrons faire une présentation expliquant les principes de base de la blockchain, ce qu’est un système distribué, ainsi que quelques exemples d’application et d’utilisation de blockchain dans différents systèmes déjà existants.

### Un cas d’application

L'objectif principal du cas d’application est de pouvoir réaliser un système distribué entre 5 machines minimum dans le but d’effectuer des authentifications centralisées.
Nous devons également mettre en place un système de log afin de garder une trace de toutes les modifications qui sont effectuées.

Pour nos machines, nous avons choisi le système d’exploitation “Debian/Ubuntu”, car il est open-source, et c’est une connue (meilleure compatibilité avec certains paquets/applications).

Pour faire communiquer les différentes machines, nous avons choisi d’utiliser le système open-source “openssh”, qui est compatible avec la plupart des systèmes Linux. OpenSSH est aussi compatible avec certains systèmes d’encryption, ce qui sera parfait pour notre projet.
Pour engager les différentes machines lors de l’attribution ou du changement de mot de passe, on pourra utiliser la commande DSH, inclue dans OpenSSH. Cette commande permet d'exécuter des commandes sur toutes les machines d’un coup, et ainsi de leur appliquer la même configuration.
On peut également utiliser cette commande lors de l’authentification d’un utilisateur, afin de comparer le mot de passe saisi par l’utilisateur, s’il est valide, avec les mots de passe présents sur les autres machines.
