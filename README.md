# Maestro Vichero del Malecon 3D

Simulador en primera persona de puesto vichero, cocina en paila de cobre martillado y destilacion en alambique con serpentin en el Malecon de Quibdo (Rio Atrato) y la Plaza de la Catedral de San Francisco de Asis, con proyecto nativo **Godot Engine 4.3** (`godot-project/`) y version web interactiva con **Rasterizador 3D Z-Buffer Per-Pixel, Perspective-Correct UV Mapping y Gouraud Smooth Shading** (`index.html`).

## Caracteristicas Principales
- **Mostrador y Estaciones 3D con Objetos Esculpidos de Alta Definicion:**
  - **Bandeja de Madera con Chontaduros Ovoides Acorazonados** (18x12 segmentos con sombreado Gouraud, brillo de miel en la parte superior y caliz).
  - **Botellas de Vidrio Torneadas de Viche Curado, Arrechon, Tomaseca y Pipilongo** con cuello curvo, liquido interior visible, reflejo especular de vidrio, corcho de cabuya y etiqueta frontal blanca/dorada.
  - **Jarra de Jugo de Borojo espumoso** y **Racimos de Popochos curvos**.
  - **Paila de Cobre Martillado** hirviendo con vapor a la izquierda y **Alambique de Cobre con serpentin espiral** a la derecha.
- **Clientes Chocoanos con Silueta y Personalidad Unica:** Atiende en primera persona a **Janfry**, **Jonyer ("Obvio Bobis")**, **Dona Cruz la Chontadurera** (con su turbante afro y batea) y **Tostao Flow Quibdoseno** (con gorra hacia atras, gafas y microfono), mas el **Mototaxista en su moto Yamaha DT** pasando por la Carrera Primera frente a la Catedral.
- **Proyecto Nativo Godot Engine 4.3 (`godot-project/`):** Escena 3D `scenes/main.tscn`, script `scripts/main.gd`, shader `shaders/psx_retro_lit.gdshader`, modelos `.glb`/`.obj` y texturas UV `.png`.

## Estructura del Repositorio
- `index.html`: Simulador 3D en primera persona completo listo para jugar en el navegador.
- `JUGAR_WINDOWS.bat`: Lanzador directo para Windows.
- `godot-project/`: Proyecto completo de Godot Engine 4.3.
- `SPEC-CURSOR-ARGON.md`: Especificacion tecnica de estaciones, recetas y arquitectura.
- `assets-psx/`: Modelos `.glb`/`.obj` esculpidos y texturas UV `.png`.
