# Système distribué

## Concept

Un système distribué est un ensemble de machines physiques connectées qui réalisent une tâche commune ou offrent un service. Ces machines communiquent par passage de messages.
Par abus de langage, on qualifie parfois de système distribué un système multiprocesseur qui partage une mémoire commune. 
Ce concept est opposé au système centralisé, composé d'une machine physique unique. 

### Avantages

Les systèmes distribués peuvent avoir des avantages par rapport à leur homologues centralisés, mais ses avantages sont souvent potentiels et non innés. En effet, le potentiel d'un système distribué dépend de son architecture, de sa gestion et des ressources qui lui sont allouées. Par exemple, un calcul ne sera pas forcément achevé plus rapidement s’il est partagé entre plusieurs machines. 

#### Redondance

Un système distribué étant par définition réparti sur plusieurs machines, il peut bénéficier des avantages de la redondance. 
 - Tolérance aux pannes: si le système est bien configuré, ses nœuds sont en capacité de fonctionner indépendamment les uns des autres. Ceci aide grandement à la tolérance de pannes matérielles.
 - Qualité de service: Puisque le système est plus tolérant aux pannes, il peut être optimisé pour garantir une qualité de service plus élevée en répartissant la charge de travail sur les nœuds opérationnels. 

#### Evolutivité

Un système distribué bien configuré permet à ses nœuds de travailler indépendamment. En plus de permettre des opérations de maintenance sans diminution de la qualité de service (comme vu précédemment), ceci fournit un environnement propice au plug-and-play. 

Les nœuds communiquant par messages, les machines individuelles peuvent fonctionner avec des versions logicielles ou de systèmes d'exploitation différents. Ceci permet de faire évoluer le parc matériel plus facilement sans problème de compatibilité.

#### Vitesse

Si l’objectif du système est le calcul ou un service dépendant de la position géographique des noeuds, le système distribué arbore des avantages:

 - La répartition de la tâche de calcul sur plusieurs machines permet d’utiliser plus de ressources (processeur, mémoire, stockage). Si la communication et la répartition de la charge sont bien configurées, ceci permet d’obtenir les résultats plus rapidement que sur un système centralisé. 
 - Les tâches ou services qui dépendent de facteurs géographiques sont évidemment réalisés sur des systèmes distribués qui exploitent leur fonctionnement en réseau pour s’adapter aux contraintes. 

#### Transparence

Pour les utilisateurs, le système distribué apparaît comme une seule entité logique avec une interface unique. Ceci permet de faciliter leur utilisation et ne pas exposer les utilisateurs à leur complexité interne. 

### Inconvénients

Tout comme les avantages, les inconvénients dépendent beaucoup de la gestion du système ainsi que de facteurs externes.

#### Complexité

L’augmentation de machines physiques est une évolution à double tranchant. En effet, la division en plusieurs noeuds comporte les inconvénients suivants:

 - Augmentation des ressources nécessaires au bon fonctionnement: que ce soit d’un point de vue matériel, énergétique ou humain, un système plus complexe nécessite plus de ressources, ce qui augmente fatalement le coût d’exploitation. Ce point est en partie contrecarré par l’utilisation de clouds, offres qui diminuent le prix d’exploitation en faisant de l’exploitation de masse. 
 - Dépendance du réseau: dans le cas d’un système étendu géographiquement, la dépendance de réseaux publics ou gérés par des prestataires externes crée des dangers supplémentaires: la diminution ou la perte des performances du réseau nuisent gravement au fonctionnement du réseau et ne peuvent pas être contrôlés par la politique QoS du système. 
 - Difficulté d’exploitation: la complexité élevée par rapport aux homologues centralisés induit une demande de collaborateurs formés pour ce genre d’exploitation, ainsi que des moyens de gestion spécifiques plus poussés. 

#### Sécurité

Il est connu que la complexité induit des risques de sécurité dans tous les domaines. L'informatique n’en est pas exempte et en est même une bonne image. Plus concrètement, les systèmes distribués sont plus ouverts aux réseaux, sont répartis sur des sites distants physiquement et sont plus compliqués à monitorer en raison de leur complexité. Chacun de ses points représente un vecteur d’attaque supplémentaire qui se base sur les failles, les erreurs humaines sur place ainsi que des limites des ressources allouées à l'exploitation. 

#### Synchronisation

Beaucoup de processus sont basés sur le temps, et ne peuvent s’exécuter convenablement qu’en étant synchronisés. Les systèmes distribués souffrent ici d’un grand défaut: distants physiquement, les nœuds ne partagent pas d’horloge commune. Ceci pose donc de grands enjeux au niveau des plus petites échelles de mesure du temps.

## Applications

Voici une liste d’implémentations courantes de systèmes distribués

### Internet

Internet est un énorme réseau constitué d’une multitude de nœuds ayant des fonctions différentes mais ayant le même objectif: le partage de l’information. Cette dernière est répartie sur des machines physiques distinctes partout dans le monde, reliées entre elles par du matériel dédié au fonctionnement du réseau. Les utilisateurs utilisent également des machines qui ont le rôle de clients. Ainsi, internet est le plus grand système distribué. 

### Blockchain

La blockchain est l'icône des systèmes décentralisés, elle est donc indissociable du concept de système distribué. C’est une technologie de stockage et de transmission de l’information qui s’appuie sur la quantité de noeuds pour garantir la sécurité. 

### Jeux multi-joueurs

Les jeux multi-joueurs fonctionnent dans la grande majorité grâce à un système client-serveur: une machine unique décide des événements qu’elle transmet aux clients qui se chargent de les représenter aux joueurs. En échange, les machines des joueurs transmettent les décisions de ces derniers à la machine centrale qui utilise ses informations pour décider des événements. 
On à donc un système étoile où chaque machine est à la fois client et serveur. 

### E-mails

Inventés dans les années 1970, les e-mails sont sans doute la première instance de système distribué. En effet, il s’agit d’un système en étoile élargi où les tâches de transfert et de stockage de l’information sont réparties entre les noeuds. 

### Torrents

Un autre exemple typique de système distribué, les torrents permettent l’échange d’information entre plusieurs machines connectées sans que l’information ne soit stockée sur une machine unique. Ce système est également dépourvu de machine maître. 

### Systèmes de calcul scientifique

La recherche scientifique requiert parfois des calculs importants qui ne peuvent pas être assumés par un système centralisé dans la plupart des pays. La charge de calcul est alors répartie sur plusieurs machines qui travaillent simultanément et compilent leurs résultats une fois qu’elles ont achevé leur tâche.  L’Ecole Polytechnique détient un serveur dédié au calcul dont elle prête le temps processeur à différentes organisations de recherche à travers le monde. 

## Sources

 - [Splunk](https://www.splunk.com/en_us/data-insider/what-are-distributed-systems.html#:~:text=A%20distributed%20system%20is%20a,been%20responsible%20for%20the%20task.)
 - [Wikipedia](https://en.wikipedia.org/wiki/Distributed_computing)




