
*⚠️ Este README se **basa** en el proyecto en **fase beta**; sin embargo, el desarrollo **actual** se encuentra aún en **fase alpha**.*

# 🚢 Hundir la Flota — Battleship en Godot 4

[![Godot 4.1+](https://img.shields.io/badge/Godot-4.1%2B-478cbf?logo=godot-engine&logoColor=white)](https://godotengine.org)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Descargas](https://img.shields.io/github/downloads/Rubenro01/hundir-la-flota/total.svg)](https://github.com/Rubenro01/hundir-la-flota/releases)
[![Issues abiertas](https://img.shields.io/github/issues/Rubenro01/hundir-la-flota.svg)](https://github.com/Rubenro01/hundir-la-flota/issues)

> *Battleship* por turnos con IA — clásico, libre y multiplataforma.

---

## 📑 Tabla de contenidos
1. [Características](#-características)
2. [Requisitos](#-requisitos)
3. [Instalación](#-instalación)
4. [Ejecución](#-ejecución)
5. [Estructura del proyecto](#-estructura-del-proyecto)
6. [Pruebas](#-pruebas)
7. [Contribuir](#-contribuir)
8. [Créditos](#-créditos)
9. [Licencia](#-licencia)

---

## ✨ Características
- **IA adaptable** con tres niveles de dificultad.
- **Drag & Drop** para colocar barcos con rotación rápida (`R`).
- **Sonido y música** con mezcla por "bus" de audio.
- Sistema de **guardado** y carga instantánea.
- Controles accesibles con ratón, teclado y mando.
- Preparado para **exports** de escritorio y Web (HTML5).

### Capturas de pantalla
| Menú principal | Colocación de barcos | Combate |
|----------------|----------------------|---------|
| ![Main menu](docs/screenshots/menu.png) | ![Place ships](docs/screenshots/place.png) | ![Gameplay](docs/screenshots/game.png) |


---

## 🖥️ Requisitos
| Software           | Versión mínima | Enlace                                                      |
|--------------------|---------------|-------------------------------------------------------------|
| **Godot Engine**   | 4.1           | <https://godotengine.org/download> |
| **Sistema operativo** | Windows • macOS • Linux | – |
| **Git** (opcional) | 2.0           | <https://git-scm.com/downloads> |

---

## ⚙️ Instalación

<details>
<summary><strong>Opción A – Clonar con Git (recomendado)</strong></summary>

```bash
git clone https://github.com/Rubenro01/hundir-la-flota.git
cd hundir-la-flota
```

</details>

<details>
<summary><strong>Opción B – Descargar ZIP</strong></summary>

1. Pulsa <kbd>Code ▾</kbd> → <kbd>Download ZIP</kbd>.
2. Extrae el contenido, p. ej. en `C:/godot-games/HundirLaFlota/`.

</details>

---

## 🚀 Ejecución
1. Abre **Godot 4** → <kbd>Import Project</kbd>.
2. Elige `project.godot` en la carpeta del repositorio.
3. Pulsa <kbd>▶ Play</kbd> o **F5**.

---

## 📂 Estructura del proyecto
```text
.godot/                 # Configuración interna de Godot
assets/
    images/             # Sprites & texturas
    sounds/             # Efectos de audio
        Barco.wav
        Limpiar.wav
        Empezar.wav
scenes/
    MainMenu.tscn       # Menú principal
    PlaceShips.tscn     # Colocación de barcos
    GameScreen.tscn     # Pantalla de juego
scripts/
    MainMenu.gd
    PlaceShips.gd
    GameScreen.gd
project.godot
LICENSE
README.md
```

---

## 🧪 Pruebas

### Manuales
| Escenario | Comprobaciones |
|-----------|----------------|
| **Menú** | Navegación, audio y resolución. |
| **Colocación** | Colisiones, rotación y límites del tablero. |
| **Juego** | Aciertos/fallos, reglas de turnos, IA coherente. |
| **Sonido** | Eventos: colocar, limpiar, continuar. |
| **Fin** | Mensaje de victoria/derrota y reinicio. |

### Automatizadas
Ejecuta las *unit tests*:
```bash
godot --headless --run-tests
```

---

## 🤝 Contribuir
¡Toda ayuda es bienvenida! Para aportar código, por favor:
1. Haz *fork* del proyecto.
2. Crea una rama: `git checkout -b feature/mi-mejora`.
3. Commitea: `git commit -m "Añade característica X"`.
4. Haz *push*: `git push origin feature/mi-mejora`.
5. Abre una **Pull Request** con tu propuesta.

Consulta `CONTRIBUTING.md` para más detalles.

---

## 👥 Créditos
- **Diseño y desarrollo:** Rubén Rodríguez Porras
- **Motor de juego:** [Godot Engine 4](https://godotengine.org)

---

## 📄 Licencia
Distribuido bajo la licencia **MIT**. Consulta [`LICENSE`](LICENSE) para más información.
