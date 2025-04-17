Unmix GUI
=========

English below.

.. TODO screenshot

Français
--------

Unnmix GUI permet d'utiliser `Open-Unmix
<https://sigsep.github.io/open-unmix/>`_ et le modèle umx1
pour décomposer un fichier audio musical en quatre pistes :

- percussions,
- basse,
- chant,
- autre.

Tous les formats audio sont supportés à partir du moment où
`ffmpeg` peut les convertir. Le modèle est entraîné sur de
la Pop, donc pour le Black Metal ça ne marchera pas bien,
même si sur la plupart de mes tests le résultat est
acceptable.

Utilisation directe
*******************

Pour UN*X ou WSL, assurez-vous d'avoir ffmpeg d'intallé et clonez le repo :
```
sudo apt install -y ffmpeg
git clone https://github.com/erwan-privat/unmix-gui
```
Pour lancer la décomposition, entrez dans le répertoire du repo et lancez le script avec le chemin complet du morceau de musique :
```
cd unmix-gui
./umx.sh morceau.mp3
```
Par défaut un sous-dossier sera créé avec le même nom que le morceau contenant les pistes séparées.

IMPORTANT : pour l'instant le projet n'est pas fourni avec UMX. Faites en sorte d'avoir le script umx dant votre PATH en attendant que je peaufine ça.

Payez-moi un coup sur `Ko-Fi <https://ko-fi.com/eprivat/goal?g=0>`_
si vous appréciez mon travail.

À faire
*******

- [ ] Choisir les pistes à extraire.
- [ ] Mixer directement une version drumless/karaoke.
- [ ] Lecteur audio intégré.
- [ ] Fichiers multiples/batch.
- [ ] Installation automatique des bibliothèques, y compris UMX.

English
-------

Unmix GUI provides a Graphical User Interface to process
musical files through the `Open-Unmix
<https://sigsep.github.io/open-unmix/>`_ implementation
using the umx1 training data. Works best for pop music, but
tests on messy black metal tracks show acceptable results.

Give me a tip on `Ko-Fi <https://ko-fi.com/eprivat/goal?g=0>`_
if you like my work.

Direct use
**********

For UN*X or WSL, make sure you have ffmpeg installed and clone the repo:
```
sudo apt install -y ffmpeg
git clone https://github.com/erwan-privat/unmix-gui
```
To launch unmixing, go into the repo dir and launch the `umx.sh`script with the path of the track:
```
cd unmix-gui
./umx.sh morceau.mp3
```
By default a sub-directory will be created containing all instruments' tracks.

IMPORTANT: For now the project is not shipped with UMX, it is a work in progress. Make sure that you have umx in your path while I work on that.

TODO
****

- [ ] Choose which tracks to extract.
- [ ] Use residuals to make drumless/karaoke version.
- [ ] Audio player for preview.
- [ ] Multiple files/batch mode.
- [ ] Automatic install of libs including UMX.
