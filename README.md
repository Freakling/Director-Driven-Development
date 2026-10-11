# Director-Driven Development

Documentation for Director-Driven Development, a way of working with AI coding agents: you direct, agents build, an automatic check proves every task.

Site: https://freakling.github.io/Director-Driven-Development/

The blog explains why: https://saemundsson.se/2026/10/07/director-driven-development/. The docs explain how. The three frameworks keep their own README and procedures as the source of truth, and the docs link to them:

- [Godot-Director](https://github.com/Freakling/Godot-Director): games in Godot 4
- [App-Director](https://github.com/Freakling/App-Director): small web, mobile and desktop apps
- [SaaSAllTheThings](https://github.com/Freakling/SaaSAllTheThings): multi-tenant B2B SaaS on Azure

## Working on the docs

The site is built with [MkDocs](https://www.mkdocs.org/) and the Material theme. Pages are Markdown in `docs/`; the navigation is in `mkdocs.yml`; the look follows the graphical profile in `docs/assets/stylesheets/ddd.css`.

```
pip install -r requirements.txt
mkdocs serve          # preview at http://127.0.0.1:8000
bash selftest.sh      # before every push
```

`selftest.sh` fails on:

- en or em dashes in the sources;
- any command or skill a framework ships that its framework page doesn't mention (it clones the three repos; set `FRAMEWORKS_DIR` to use existing clones);
- broken internal links and anchors (`mkdocs build --strict`).

GitHub Actions runs the selftest on every push and pull request, and deploys `main` to GitHub Pages.

## License

© 2026 Vikingur Saemundsson. The bundled fonts, Archivo and IBM Plex Mono, are under the SIL Open Font License (`docs/assets/fonts/`).
