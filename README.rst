Unmix GUI
=========

English below.

.. TODO screenshot

Français
--------

Unnmix GUI permet d'utiliser `Open-Unmix
<https://sigsep.github.io/open-unmix/>`_ et le modèle umx1
pour décomposer un fichier audio musical en quatre pistes :

  * percussions,
  * basse,
  * chant,
  * autre.

Tous les formats audio sont supportés à partir du moment où
`ffmpeg` peut les convertir. Le modèle est entraîné sur de
la Pop, donc pour le Black Metal ça ne marchera pas bien,
même si sur la plupart de mes tests le résultat est
acceptable.

À faire
*******

- [ ] Choisir les pistes à extraire.
- [ ] Mixer directement une version drumless/karaoke.
- [ ] Lecteur audio intégré.
- [ ] Fichiers multiples/batch.

English
-------

Unmix GUI provides a Graphical User Interface to process
musical files through the `Open-Unmix
<https://sigsep.github.io/open-unmix/>`_ implementation
using the umx1 training data. Works best for pop music, but
tests on messy black metal tracks show acceptable results.

TODO
****

- [ ] Choose which tracks to extract.
- [ ] Use residuals to make drumless/karaoke version.
- [ ] Audio player for preview.
- [ ] Multiple files/batch mode.
