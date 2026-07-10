# SURAKI

**SURAKI** ist ein 2D-Puzzle-Adventure über das Überleben auf einer geheimnisvollen Insel. Der Spieler nutzt Zeitreisen, um Hindernisse zu überwinden und den Weg zum Leuchtturm zu finden.

Du öffnest deine Augen und stellst fest, dass du dich auf einer Insel befindest, umgeben von Wasser. Dort zu bleiben ist keine Option, also machst du dich auf den Weg. Schon bald entdeckst du eine besondere Fähigkeit: Du kannst durch die Zeit reisen. Auf deiner Reise triffst du auf verschiedene Hindernisse, die nur durch den Wechsel zwischen Vergangenheit und Gegenwart gelöst werden können. Wenn du schließlich die Spitze des Leuchtturms erreichst, kannst du stolz sagen, dass du überlebt hast.

## Spielprinzip

SURAKI verbindet Erkunden, Interaktion und zeitbasierte Rätsel. Der Spieler bewegt sich durch eine seitlich scrollende Inselwelt und nutzt Zeitreisen, um den Zustand der Umgebung zu verändern. Manche Objekte verhalten sich in der Vergangenheit anders als in der Gegenwart. Dadurch können Aktionen in einer Zeit Auswirkungen auf spätere Bereiche des Levels haben.

Zentrale Spielmechaniken:

- Wechsel zwischen Vergangenheit und Gegenwart
- Lösen von Rätseln in Vergangenheit und Gegendwart
- Sammeln und Verwenden von Gegenständen
- Interaktion mit Objekten und Dialogereignissen
- Vermeiden tödlicher bereiche (Wasser)
- Erreichen des Leuchtturms als Ziel des Spiels

## Steuerung

A, D : laufen
SHIFT: Schneller laufen 
Space:  Springen 
Q:      Zeitreise 
E:      Interagieren 
W,S:    Hoch- oder Runterklettern
I:      Inventar anzeigen |
ESC     Menü öffnen 

## Gegenstände und Interaktionen

Einige Objekte können aufgenommen oder durch Interaktion verändert werden. Gegenstände können außerdem genutzt werden, um Rätsel zu lösen.

Beispiele:

Baumstumpf mit Axt:   Durch Interaktion erhält der Spieler eine Axt. 
Axt: Kann genutzt werden, um einen Baum zu fällen. 
Setzling: Kann im Inventar getragen und möglicherweise eingepflanzt werden. 
Holzbretter: Können genutzt werden, um die Höhle zu stabilisieren

## Projektinformationen

Dieses Projekt wurde mit **Godot** im Rahmen von `gaejam SoSe26` entwickelt.

Verwendete Technologien und Systeme:

- Godot 4
- GDScript
- Dialogic 2 für Dialog-Timelines
- eigenes Timeobject-System für Rätselzustände in Vergangenheit und Gegenwart
- Web-Export für itch.io

## Projektstruktur

```text
.
├── Assets/              # Grafiken, Audio, Fonts und weitere Spielassets
├── Resources/           # Godot-Ressourcen, Items und wiederverwendbare Daten
├── Scenes/              # Spielszenen, Level, UI und Game-Elemente
├── Scripts/GD-Scripts/  # Gameplay-, UI-, Player- und Manager-Skripte
├── addons/              # Godot-Add-ons, z. B. Dialogic
├── Tests/               # Testressourcen
├── project.godot        # Godot-Projektkonfiguration
└── export_presets.cfg   # Export-Konfiguration
```

Wichtige Script-Bereiche:

```text
Scripts/GD-Scripts/
├── Autoload/      # globale Zustände und Save-/Load-Logik
├── Interactables/ # interagierbare Objekte und Timeobjects
├── Manager/       # Parallax- und Timeobject-Manager
├── Player/        # Bewegung, Interaktion und Zeitreise-Komponenten
└── UI/            # Menü, Inventar und Game-Over-UI
```

Dieses Projekt steht unter der MIT-Lizenz. Weitere Informationen befinden sich in der Datei `LICENSE`.

## Credits
Die Texturen wurden mit Ausnahme des Player-Spritesheets (zu finden unter: https://opengameart.org/content/mv-platformer-male-32x64) alle selbst erstellt
Erstellt im Rahmen von `gaejam SoSe26`.

Entwickelt mit Godot und Dialogic 2.
