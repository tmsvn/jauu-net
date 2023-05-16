---
title: "Wechsel zu Hugo"
date: 2023-05-16T15:21:21+02:00
draft: false
toc: false
# description: "Description"
editPost:
    URL: "https://github.com/hgn/jauu-net/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
hideSummary: false
ShowRssButtonInSectionTermList: true
---

Wie so oft, wenn Dinge nicht aktiv genutzt werden, verkommen sie. So war es
auch mit dieser Website. Inhaltlich gab es, zumindest von meiner Seite, nichts
zu beanstanden. Was im Laufe der Zeit zum Problem wurde, war das Fehlen von TLS
(HTTPS). Seit vielen Jahren war die Webseite auch über IPv6 erreichbar - aber
Github unterstützte IPv6 nicht. Aber wie kam Github ins Spiel: Ich wollte den
Buildprozess der Website vereinfachen. Bisher habe ich die Daten lokal gebaut
und per scp auf den Server geschoben. Diese Indirektion wollte ich vermeiden -
ein einfacher `git push` sollte alle notwendigen Aktionen auslösen.

Da Gitlab nun IPv6 für Webseiten unterstützt, wollte ich die Umstellung an
einem Wochenende angehen. Die Frage war nur, welche Webseiten ich generieren
sollte. Da ich keine dynamischen Inhalte anbiete, zumindest nicht auf der
Hauptdomain, ist ein statischer Webseitengenerator die naheliegende Wahl. Da
ich aber die Gunst der Stunde nutzen wollte, habe ich die Modernisierung auch
gleich genutzt, um auf Hugo umzusteigen. Der Vorteil ist die Mehrsprachigkeit -
darauf wollte ich nicht verzichten.

Leider war es technisch nicht so einfach ältere Seiten mit zu migrieren, daher
habe ich nur wenige Seiten migriert. Alle Inhalte sind aber im Internetarchiv
zu finden.

