# workOrderApp

Didata new WorkOrder app made in Flutter Dart.

## Installation

Some links/instructions below to improve installation of the app:

Flutter installatie: 

- https://flutter.dev/docs/get-started/install/windows 
- https://www.javatpoint.com/flutter-installation

 
Zorg dat alle SDK's zijn geinstalleerd. Check regelmatig via het commando Flutter Doctor wat de status is van de installatie.
Intalleer Android Emulator als je geen android device hebt.
Als je wel een android device hebt en hier op wilt testen, moet eerst de ontwikkelaarsinstellingen ontgrendeld en toegepast worden.
(https://developer.android.com/studio/debug/dev-options)

Zorg ervoor dat alle vereisten, behalve de licenses, groen zijn voordat je doorgaat.

Voor de laatste stap, het accepteren van de android licenses, kan het zijn dat er een exception in de vorm van 
'Exception in thread "main" java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema' komt na het uitvoeren van de commando. 
Dit is op te lossen door Android Studio op te starten -> Configure -> SDK Manager -> Tabblad 'SDK Tools' 
   						      -> Aanvinken & installeren Android SDK Command-line-tools.

Run hierna nog een keer het commando Flutter doctor. Alle licenses worden nu wel opgehaald. Accepteer ze een voor een door 'y' in te voeren
in je commandline.


Als je bij het deployen van het project 'null' errors krijgt: 
https://stackoverflow.com/questions/64917744/cannot-run-with-sound-null-safety-because-dependencies-dont-support-null-safety

Volg het geaccepteerde antwoord en voeg deze command toe aan jouw gebruikte editor.

Emulator not working?
In het geval dat de emulator niet werkt met foutmelding Emulator_[X] was terminated, volg deze stappen:
Bij HP computers wordt een standaard software pakket geïnstalleerd, deze zorgt voor conflicten met Android studio emulators, je kan rechtsonderin bij HP Fox alles disablen, om vervolgens in Windows search 'Services' op te zoeken en alles met HP Sure click uit te zetten. Dit doe je via het eigenschappen venster (Schakel ook automatisch aanzetten bij opstarten PC).
Ga vervolgens naar android studio en deïnstalleer alle android API's en SDK's. Start de computer opnieuw op en installeer de API's en SDK's.
Via de AVD manager kan je vervolgens weer proberen een emulator aan te maken.

### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
