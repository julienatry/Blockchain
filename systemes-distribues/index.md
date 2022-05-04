# Système distribué

## Concept

Un système distribué est un ensemble de machines physiques connectées qui réalisent une tâche commune.
La nature des tâches effectuées ne définit pas le système, c'est une notion physique. 
Ce concept est opposé au système centralisé, composé d'une machine physique unique. 

### Avantages

Les systèmes distribués peuvent avoir des avantages par rapport à leur homologues centralisés, mais ses avantages sont souvent potentiels et non innés. En effet, le potentiel d'un système distribué dépend de son architecture, de sa gestion et des ressources qui lui sont allouées. 
Les avantages principaux sont les suivants:

 - Redondance: Puisque le système est constitué de plusieurs machines physiques, il peut être plus tolérant aux pannes et avoir une qualité de service plus élevée. Ceci permet aussi d'avoir une redondance de l'information plus fiable que sur un système à machine unique. 
 - Evolutivité: La répartition sur plusieurs nœuds permet la réalisation d'opérations de maintenance et d'évolution matérielle et logicielle sans arrêt de service, les nœuds opérationnels se répartissant les tâches. Un bon management des nœuds peut aussi permettre le plug-and-play.
 - Vitesse: la répartition d’une tâche sur plusieurs machines peut accélérer son exécution, bien que ce fait soit soumis à beaucoup de facteurs physiques et logiques. 
 - Transparence: pour un client, le système apparaît comme une entité logique unique, garantissant la facilité d’utilisation

### Inconvénients

Tout comme les avantages, les inconvénients dépendent de beaucoup de la gestion du système ainsi que de facteurs externes. Celà dit, les inconvénients suivants sont probables:

 - Complexité: bien que la redondance augmente la tolérance aux pannes, elle crée aussi de la complexité qui est elle-même source de pannes. En effet, l’exploitation de plus de machines crée plus d'occurrences de pannes matérielles. Puisque les systèmes distribués fonctionnent en réseaux, ils sont aussi sujets aux contraintes de ces derniers, surtout s' ils sont exploités sur un réseau public. Cette complexité se traduit aussi par des difficultés d’entretien et de management.
 - Risques de sécurité: La taille et la complexité des systèmes distribués augmentent la quantité de vecteurs d’attaque et rendent le monitoring plus compliqué. 
 - Synchronisation: les systèmes distribués ne partagent pas d’horloge commune entre les nœuds comme c’est le cas pour les systèmes centralisés. Les tâches nécessitant une synchronisation nécessitent donc une implémentation plus complexe. 

## Applications

Voici plusieurs exemples d’applications actuelles du système distribué:

 - Internet
 - Blockchain
 - Jeux multi-joueurs
 - Torrents
 - Systèmes de calcul scientifique
 - Systèmes décentralisés

## Sources

[Splunk](https://www.splunk.com/en_us/data-insider/what-are-distributed-systems.html#:~:text=A%20distributed%20system%20is%20a,been%20responsible%20for%20the%20task.)
