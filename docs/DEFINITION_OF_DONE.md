# Definition of Done (une feature est terminée quand…)

- [ ] La spec est validée par l'humain et chaque AC a un test (ou une procédure `[MANUEL]` exécutée).
- [ ] Les tests ont été écrits avant le code (historique de commits `test(...)` puis `feat(...)`).
- [ ] CI verte : `role-guard`, `quality` (lint + tests), `android-debug`.
- [ ] Code typé strictement, communication par signaux, aucune écriture dans `res://`.
- [ ] Pas d'allocation dans la boucle de jeu ; pools utilisés où nécessaire.
- [ ] ADR rédigé si une décision d'architecture a été prise.
- [ ] PR relue par un humain (propriétaire CODEOWNERS).
- [ ] Notes de version à jour si la feature est visible du joueur.
