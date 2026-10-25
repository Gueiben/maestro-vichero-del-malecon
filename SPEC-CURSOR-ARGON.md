# Especificacion Tecnica de Produccion: "Maestro Vichero del Malecon" (Simulador Fluvial Chocoano)

**Preparado para:** Andres Gallego
**Motor / Stack Recomendado para PC (Steam):** Godot 4.x (3D / 2.5D First-Person) o Three.js / React Three Fiber + Rapier Physics (empaquetado con Electron/Tauri + Steamworks.js).
**Referentes Directos:** *Schedule I* (AppID 3164500), *Supermarket Simulator* (AppID 2670630), *TCG Card Shop Simulator* (AppID 3070070) y *Dave the Diver* (AppID 1868140).

---

## 1. Vision de Arquitectura del Sistema (4 Estaciones Tactiles + Mundo Ribereño)

El jugador opera un puesto de madera sobre pilotes en el **Malecon de Quibdo (Rio Atrato)** y el embarcadero de **Istmina (Rio San Juan)**. El loop central sigue la regla de oro de *Schedule I*: **ninguna produccion ocurre en un menu abstracto; cada accion es una estacion fisica con estados claros**.

```text
[Muelle de Champas (Insumos + Rarezas)]
       |
       +---> [Estacion 1: Fogon de Leña y Paila] ---> Vasos de Chontaduro (Sal/Miel) y Patacones de Popocho
       |
       +---> [Estacion 2: Alambique + Mesa de Curado] ---> Botellas Curadas (Arrechon, Pipilongo, Tomaseca, Borojo 200 HP)
       |
       v
[Estacion 3: Ventanilla del Malecon + Celular de Encargos] ---> Cobro en Efectivo + Efectos Visuales en los Clientes
```

---

## 2. Maquina de Estados de las Estaciones Interactivas (1ra Persona)

### A. Estacion 1: Fogon de Leña, Paila de Cobre y Batea
- `IDLE`: Olla vacia esperando racimos de Chontaduro o manos de Popocho.
- `BOILING (0..100%)`: El jugador alimenta la leña. Entre `80%` y `95%` es el **"Punto de Sabrosura"** (otorga bono de calidad). Si pasa de `100%`, el agua se rebosa.
- `DRESSING (Aderezo Tactil)`: El jugador pasa el Chontaduro cocinado al vaso y aplica click-and-hold con el **Salero de Monte** y el **Tarro de Miel de Abejas**.

### B. Estacion 2: Alambique y Mesa de Alquimia de Botellas Curadas (Motor Compartido con *La Paila del Atrato*)
El motor combinatorio recibe una base liquida (`VICHE_PURO` o `JUGO_BOROJO`) y hasta 3 modificadores botanicos (`BOROJO_SELVA`, `PIPILONGO_RAIZ`, `MIEL_MONTE`, `LECHE_COCO`, `CLAVO_CANELA`, `AZOTEA_POLEO_CIMARRON`) y resuelve deterministicamente la receta y sus **Tags de Efecto en el Cliente**:

```json
{
  "recipes": [
    {
      "id": "arrechon_relampago",
      "name": "Arrechon Relampago del Atrato",
      "inputs": ["VICHE_PURO", "BOROJO_SELVA", "LECHE_COCO", "MIEL_MONTE"],
      "basePrice": 22,
      "peakPhase": "NOCHE_CHIRIMIA",
      "clientStatusEffect": {
        "id": "PURA_CANDELA",
        "vfx": "GOLDEN_SPARKS_AND_DANCE_AURA",
        "speedMultiplier": 2.0,
        "tipMultiplier": 2.0
      }
    },
    {
      "id": "curado_pipilongo",
      "name": "Curado de Pipilongo Chocoano",
      "inputs": ["VICHE_PURO", "PIPILONGO_RAIZ", "CLAVO_CANELA"],
      "basePrice": 25,
      "peakPhase": "AGUACERO_CHOCOANO",
      "clientStatusEffect": {
        "id": "FUEGO_DE_SELVA",
        "vfx": "THERMAL_RAIN_SHIELD",
        "reputationBonus": 15
      }
    },
    {
      "id": "tomaseca_sabedora",
      "name": "Tomaseca de Sabedora",
      "inputs": ["VICHE_PURO", "AZOTEA_POLEO_CIMARRON", "MIEL_MONTE"],
      "basePrice": 20,
      "peakPhase": "MANANA_CHAMPA",
      "clientStatusEffect": {
        "id": "BENDICION_DEL_RIO",
        "vfx": "HERBAL_AROMA_WAVE",
        "spawnExtraCustomers": 2
      }
    },
    {
      "id": "borojo_motor_200hp",
      "name": "Borojo Potenciado Motor 200 HP",
      "inputs": ["BOROJO_SELVA", "MIEL_MONTE", "LECHE_COCO"],
      "basePrice": 18,
      "peakPhase": "MEDIODIA_PICANTE",
      "clientStatusEffect": {
        "id": "MOTOR_200HP",
        "vfx": "CYAN_SPRINT_TRAIL",
        "speedMultiplier": 1.8
      }
    }
  ]
}
```

### C. Estacion 3 y 4: IA de Clientes Ribereños y Muelle de Champas
- **Arquetipos de NPC:** `MOTORISTA_PANGA` (prioriza Borojo 200 HP y Chontaduro), `MUSICO_CHIRIMIA` (prioriza Arrechon y Tomaseca), `SABEDORA_RIO` (prioriza hierbas de azotea y Chontaduro Amarillo Legendario), `BAREQUERO_NEGUA` (paga con pepitas o billetes grandes en dias de lluvia).
- **Sistema de Rarezas en el Barranco (Tipo *TCG Card Shop Simulator*):** Cada vez que el jugador compra y abre un bulto de Chontaduro recien bajado de una champa de Boraudo, se ejecuta una tirada de rareza (`25%` en el prototipo, `5%` en balance final) que genera un **Chontaduro Amarillo Legendario sin Espina (x5 valor de mercado)**.

---

## 3. Prompts Listos para Pegar en Cursor con Gemini Argon

### Prompt 1: Controlador de Estaciones Interactivas y Mezclador Tipo Schedule I
> "Actua como un Senior Gameplay Architect especialista en simuladores en primera persona como Schedule I y Supermarket Simulator. Toma los archivos `/workspace/pacifico-game/maestro-vichero/index.html` y `SPEC-CURSOR-ARGON.md` y estructura el proyecto en modulos desacoplados (`stations/FogonStation.ts`, `stations/AlambiqueMixer.ts`, `ai/MaleconCustomerManager.ts`, `weather/ChocoWeatherCycle.ts`). Implementa una mesa de mezcla drag-and-drop donde verter Viche Puro, Borojo, Pipilongo, Miel y Hierbas de Azotea calcule en tiempo real los tags de efecto (`PURA_CANDELA`, `FUEGO_DE_SELVA`, `BENDICION_DEL_RIO`, `MOTOR_200HP`) y aplique shaders/particulas al cliente cuando bebe frente a la ventanilla."

### Prompt 2: Conexion de Universo Compartido entre los Dos Juegos
> "Crea un paquete compartido `packages/choco-core-recipes` que exporte el catalogo JSON de ingredientes, aderezos, reliquias de chirimia y recetas de botellas curadas para que tanto el Juego 1 (`la-paila-del-atrato`) como el Juego 2 (`maestro-vichero`) consuman exactamente las mismas definiciones y formulas matematicas."
