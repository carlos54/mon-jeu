# Vérifications périodiques du Producer

À chaque réveil :
1. `gh pr list --state open` puis `gh pr checks <n>` pour chaque PR ouverte.
2. `gh run list --branch main --limit 5` : la branche `main` doit rester verte.
3. S'il y a une PR verte en attente de relecture humaine depuis plus de 24 h, la signaler.
4. S'il y a un échec CI sans handoff en cours, créer le handoff vers l'agent concerné
   (tests → qa, code → dev, pipeline → release).
5. Si rien à signaler, ne rien envoyer.
