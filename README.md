Hundir la Flota
Este es un emocionante juego de estrategia en el que podrás enfrentarte a una IA en un combate naval. El juego está desarrollado en Godot Engine 4.

Requisitos del Sistema
Antes de empezar, asegúrate de contar con lo siguiente:

Godot Engine 4.1 o superior: Descarga la última versión desde godotengine.org.
Sistema Operativo: Windows, macOS o Linux.
Git (opcional): Si deseas clonar el repositorio directamente desde un sistema de control de versiones.
Configuración del Proyecto
Paso 1: Descargar el proyecto
Opción 1: Descarga el proyecto desde un archivo comprimido:

Extrae el contenido en una carpeta de tu elección, como C:/godot-games/HundirLaFlota.
Opción 2: Clonar el repositorio (si tienes Git instalado):

bash
Copiar código
git clone <[URL_DEL_REPOSITORIO](https://github.com/Rubenro01/hundir-la-flota)>
cd HundirLaFlota
Paso 2: Abrir el proyecto en Godot
Abre Godot Engine 4.
Haz clic en Importar Proyecto.
Navega a la carpeta donde descargaste el proyecto (por ejemplo, C:/godot-games/HundirLaFlota).
Selecciona el archivo project.godot y haz clic en Importar y Editar.
Ejecución del Juego
Una vez que el proyecto esté cargado en Godot, selecciona la escena principal:
Ve a la carpeta scenes y abre MainMenu.tscn.
Haz clic en el botón de Reproducir (icono ▶️) o presiona F5 en tu teclado.
El juego se ejecutará desde el menú principal.

Pruebas del Juego
Pruebas Manuales
Interfaz Inicial:

Comprueba que el menú principal funcione correctamente.
Accede a las opciones de configuración y asegúrate de que los botones respondan.
Colocación de Barcos:

Arrastra y suelta los barcos en el tablero.
Verifica que los barcos no se superpongan ni salgan de los límites.
Gira los barcos usando el botón de rotación.
Juego Principal:

Selecciona una casilla en el tablero enemigo para disparar.
Verifica que los aciertos y fallos se registren correctamente.
Observa el turno de la IA y asegúrate de que siga las reglas.
Sonidos:

Asegúrate de que los sonidos se reproduzcan en las siguientes acciones:
Colocación de barcos.
Limpieza del tablero.
Al presionar el botón "Continuar".
Finalización del Juego:

Comprueba que se muestre el mensaje de victoria o derrota cuando se destruyan todos los barcos de un jugador.
Estructura del Proyecto
La estructura del proyecto es la siguiente:

plaintext
Copiar código
├── .godot/              # Archivos de configuración de Godot
├── assets/
│   ├── images/          # Recursos gráficos (no visibles en este ejemplo)
│   ├── sounds/          # Efectos de sonido
│       ├── Barco.wav    # Sonido al colocar un barco
│       ├── Limpiar.wav  # Sonido al limpiar el tablero
│       ├── Empezar.wav  # Sonido al iniciar el juego
├── scenes/
│   ├── MainMenu.tscn    # Escena principal
│   ├── PlaceShips.tscn  # Escena para colocar barcos
│   ├── GameScreen.tscn  # Escena principal del juego
├── scripts/
│   ├── MainMenu.gd      # Lógica del menú principal
│   ├── PlaceShips.gd    # Lógica para la colocación de barcos
│   ├── GameScreen.gd    # Lógica del juego principal
├── project.godot        # Archivo del proyecto
└── README.md            # Este archivo
Créditos
Diseño y desarrollo: [Tu Nombre o Equipo]
Motor del juego: Godot Engine 4
Licencia
Este proyecto está licenciado bajo MIT License.
