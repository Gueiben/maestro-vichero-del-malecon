# Maestro Vichero del Malecon

Simulador en primera persona de puesto ribereño, cocina en paila y alquimia de botellas curadas (viche, arrechon, tomaseca, borojo y pipilongo) en el Malecon de Quibdo (Rio Atrato) e Istmina (Rio San Juan) con estetica 3D Low-Poly PSX para PC en Steam.

## Concepto y Loop Jugable
Opera 4 estaciones tactiles sin menus abstractos al ritmo del clima chocoano y las champas que llegan por el rio:
1. **Estacion 1 - Fogon de Leña y Paila:** Cocina racimos de chontaduro (incluyendo el raro **Chontaduro Amarillo Legendario x5**) y manos de popocho en su punto exacto de sabrosura y aderezalos con sal de monte y miel.
2. **Estacion 2 - Alambique y Mesa de Curado:** Destila viche puro y mezclalo con borojo, raiz de pipilongo, leche de coco, clavo, canela y hierbas de azotea en canoa (poleo y cimarron) para embotellar cepas con efectos reales en los clientes del malecon (`PURA_CANDELA`, `FUEGO_DE_SELVA`, `BENDICION_DEL_RIO`, `MOTOR_200HP`).
3. **Estacion 3 - Ventanilla del Malecon de Quibdo:** Despacha bajo el sol picante o el aguacero chocoano (que dispara +200% la demanda de chontaduro caliente y curados) y observa las reacciones festivas al son de la chirimia.
4. **Estacion 4 - Muelle de Champas y PangaExpress:** Compra bultos a las champas de Boraudo y Negua e impulsa encargos fluviales por celular.

## Estructura del Repositorio
- `index.html`: Prototipo interactivo jugable con las 4 estaciones, ciclo climatico fluvial, mesa de alquimia y sintetizador Web Audio API.
- `SPEC-CURSOR-ARGON.md`: Arquitectura de maquina de estados, arbol combinatorio de recetas y prompts para Cursor y Gemini Argon.
- `assets-psx/textures/`: las 8 texturas `64x64` en 15-bit RGB555 con dithering Bayer 4x4 exclusivas de *Maestro Vichero del Malecon*.
- `assets-psx/models/`: Modelos 3D Low-Poly (`.obj` y `.mtl`) del puesto, alambique, champa e ingredientes.
- `assets-psx/shaders/`: Shaders GLSL (Three.js/WebGL) y `.gdshader` (Godot 4) con vertex snapping, niebla de aguacero y dithering PSX.
