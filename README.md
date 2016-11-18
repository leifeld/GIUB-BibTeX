GIUB-BibTeX
===========

BibTeX citation style for the Geographic Institute at the University of Bonn.

This BibTeX style, giub.bst, is an inofficial implementation of the citation and bibliography requirements as set out by the Geographic Institute of the University of Bonn (GIUB), Germany. The guidelines can be found online at [http://www.geographie.uni-bonn.de/lehre-und-studium/lehre-am-institut/zitieranleitung/](http://www.geographie.uni-bonn.de/lehre-und-studium/lehre-am-institut/zitieranleitung/) as of November 29, 2013.

### GIUB features include particularly:

* formatting all but the last author or editor names as ``lastname, firstname``, and the last one as ``firstname lastname``, all with abbreviated first names and in small caps
* editions as superscripts following the year field
* adding ``(Hrsg.)`` to the editor field
* formatting empty year or address fields as ``o.J.`` or ``o.O.``, respectively
* book or journal titles preceded by ``In: ``
* page numbers preceded by ``S. ``
* publisher field in parentheses

### Usage of giub.bst:

* Put giub.bst in the same folder as the .tex file you are using.
* Use the style together with the ``natbib`` package, i.e., write ``\usepackage{natbib}`` in the preamble of your LaTeX document.
* At the end of your document, write ``\bibliographystyle{giub}`` and ``\bibliography{bibfile}``, where ``bibfile`` is the bibliography file to be used (without .bib).
* In order to omit the comma in the author-year citation in the text, place a command like ``\bibpunct[: ]{(}{)}{;}{a}{}{,}`` in your preamble.

### Some additional hints and known issues:

* Author or editor names with two first names separated by a hyphen, e.g. Karl-Heinz or Jean-Paul, are abbreviated as K.H. or J.P., respectively, instead of K.-H. or J.-P. A possible workaround can be found here: [ftp://ftp.tex.ac.uk/tex-archive/biblio/bibtex/contrib/doc/btxFAQ.pdf](ftp://ftp.tex.ac.uk/tex-archive/biblio/bibtex/contrib/doc/btxFAQ.pdf) (question 35).
* The GIUB guidelines propose separating the volume and number fields using commas. The fields may be preceded by the abbreviations ``Bd. `` and ``Nr. ``, but this is not mandatory according to the official guidelines. I decided not to implement these abbreviations into giub.bst.
* The ``crossref`` field for cross references is not used. (This should not affect the average user.)
* The ``month`` field is not used. Likewise, macros have not been defined. (This should not affect the average user.)
* URLs are included as proposed by the guidelines, but are not bold or clickable. If desired, you may use ``\usepackage{url}`` in your preamble and embrace the URLs in your bib file using a ``\url{}`` command.
* The date in the URL field is only formatted according to the requirements if the document language is ``german`` or ``ngerman``. You may switch between several languages in your LaTeX document using the ``\setlanguage`` command. The date for the URL field is always the current date as set by ``\today``. If you would like to set a specific date (unlike the current date), you can enter the URL plus the other information like "Abrufbar unter", "Datum: ", etc. in the ``notes`` field, which is always added to the end of the bib entry.
* Reprints of journal articles are not treated separately. Please include "(Wiederabdruck mit Kuerzungen in: WIRTH, E. (Hg.) (1969): Wirtschaftsgeographie. Darmstadt, S. 441-485.)" or something similar in the notes field if desired.
* Inbook entries are generally rarely used (only in pure literature lists like examination preparation lists, if at all). However, there is a small inconsistency for inbooks in giub.bst: If the chapter and the pages entry are both present, they will be placed after the publisher and address, preceded by a comma. If the pages are not present, however, the chapter will be preceded by a period. (This should not affect the average user.)
* Sometimes, people enter the total number of pages of a book into the pages field. You should not do this when using giub.bst.

### Version history

Version __0.4__ (released 18 November 2016):

* Updated affiliation.

Version __0.3__ (released 29 November 2013):

* Updated contact information and warning messages.

Version __0.2__ (released 26 March 2009):

* ``mastersthesis`` entries are now recognized correctly. In the previous version, there was a typing mistake that would only allow for ``masterthesis`` entries (i.e., the s was missing).
* If you use a ``misc`` entry, and you do not use the field ``howpublished``, and you add something to the ``url`` field, this is now handled correctly. In version 0.1, the url was written in a new line.
* ``techreport`` entries now support ``url`` and ``note`` fields.
* German umlauts were replaced by other characters in the description and warning messages in order to avoid trouble with the character encoding (UTF-8 versus CP-1252, etc.).

Version __0.1__ (released 4 January 2008):

* first public version.

### Author

The giub.bst BibTeX style was written by __Philip Leifeld__ ([http://www.philipleifeld.de](http://www.philipleifeld.de)). Please report bugs at http://github.com/leifeld/GIUB-BibTeX.
