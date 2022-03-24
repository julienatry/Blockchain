# Blockchain

Authentification distribuée à l’aide de blockchains scriptées.
On propose un sujet en 2 parties:

## 1ere partie (lors de la soutenance): Présentation aux membres du Jury de ce que sont:

- Système Distribué, et son sous-ensemble Système décentralisé.
- Concept et Pratiques du BlockChain
- Quelques exemples de "usages" généraux et un usage appliqué en Informatique Système/Réseau

## 2eme partie: Cas d'application en Sécurité d'Administration

- Concevoir, si possible à base de scripting "bash" et services déjà existant en OpenSource,

=> Un système d'authentification à Forte Sécurité distribué, sur un système de 5 machines distantes physiquement ou virtuelles (5 Systèmes OpenSource), sur un compte d'accès (un login) sensible
où il faudrait un accord en distribué sur au moins 3 des 5 Systèmes distants sur le couple Login/mdp.
On pourra s'inspirer des approches diverses suggérées par les BlockChain, sans toutefois déclencher une mise en œuvre d'une vraie BCK Privée ou publique d'ailleurs.
Proposer une solution qui engage les 5 systèmes lors de l'attribution/changement d'un mot de passe, et surtout lors de l'accord à 3/5 (normalement plutôt 2/3 en distribué) pour autoriser l'ouverture d'une session sur ce Login sensible.

=> Peux-t'on envisager un "Traçage distribué" lors des changements de mdp et lors des accès à ce Login ?
