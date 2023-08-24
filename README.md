# SPAM
## _Seymour PAckage for Mudlet_
SPAM è un package Mudlet per migliorare l'esperienza di gioco in [Dei delle Ere].

## Features
SPAM include i seguenti moduli, ciascuno attivabile o disattivabile:
- DdEgroup: monitor per la gestione dei PF e dei buff del gruppo
- AbbilChat: monitor per la visualizzazione delle comunicazioni sviluppato da [Abbil]
- Gloria: timer per tracciare la gloria ottenuta nelle ultime 24 ore
- Appunti: possibilità di copiare negli appunti del sistema operativo identificazioni e valuta mostri
- NariaDB: possibilità di inviare automaticamente al database di [Nikeb] le identificazioni
- Colorazione per i PF del prompt, lo stato di usura degli oggetti
- Suoni: trillo quando si riceve un beep
- Build e test mediante [Muddler]

   
## Installazione
Per installare SPAM la prima volta è sufficiente dare in gioco il seguente comando in un'unica riga:
```
lua uninstallPackage("SPAM") installPackage("https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage")
```
Oppure scaricare ed importare in Mudlet l'[ultima release].

Per i successivi aggiornamenti è possibile utilizzare in gioco il comando <spam update>

## Utilizzo
Per esplorare tutte le funzioni del package basta digitare il comando <spam> in gioco
Per le opzioni del monitor buff è possibile digitare il comando <observe>


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [Dei delle Ere]: https://discord.gg/5X7HHaE9PN
   [Abbil]: https://moylen.eu/dde/
   [Nikeb]: http://arendil.sytes.net:5000/
   [Muddler]: https://github.com/demonnic/muddler
   [ultima release]: https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage