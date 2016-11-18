% Giub.bst is an inofficial citation style for the Geographic Institute 
% of the University of Bonn, Germany (GIUB). It was written by Philip 
% Leifeld, University of Glasgow. Please contact me at 
% http://github.com/leifeld/GIUB-BibTeX if you find errors. 
% giub.bst should be used with the natbib package. This is version 0.4. 
% It was released on November 18, 2016.

%------------------------------------------------------- preamble

ENTRY
 { author
   year
   title
   publisher
   address
   edition
   editor
   note
   URL
   booktitle
   pages
   journal
   volume
   number
   type
   school
   institution
   howpublished
   series
   chapter
   organization
 }
{ }
{ extra.label }

STRINGS { namen_liste editor_liste auflage zitation vorherige_zitation aktuelle_zitation last.label next.extra}
INTEGERS { anzahl_label namen_gesamt namen_uebrig namen_aktuell namen_zuviel editor_gesamt editor_uebrig editor_aktuell editor_zuviel last.extra.num }



%------------------------------------------------------- labels und sorting

FUNCTION {sortify}					% stolen from apalike
{ purify$
  "l" change.case$
}

FUNCTION { zitationslabel }				% generate the citation labels from
{ author empty$						% the author and year field and the
  { editor 'namen_liste := }				% extra.label string; compatible
  { author 'namen_liste := }				% with natbib
  if$
  "\textsc{" namen_liste #1 "{vv~}{ll}" format.name$ "}" * *
  namen_liste num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ namen_liste #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
	    { " u. " * "\textsc{" namen_liste #2 "{vv~}{ll}" format.name$ "}" * * * }
	  if$
	}
      if$
    }
  if$
  "(" year extra.label ")" * * * *
}

FUNCTION { sortierlabel }				% generate a sort string from the
{ author empty$						% author and year field
  { editor 'namen_liste := }
  { author 'namen_liste := }
  if$
  namen_liste num.names$ 'namen_gesamt :=
  namen_gesamt #1 - 'namen_uebrig :=
  #2 'namen_aktuell :=
  namen_liste #1 "{}{ll}{, jj}{ f}" format.name$ " " *
  namen_gesamt #1 + 'namen_zuviel :=
  { namen_aktuell namen_zuviel < }
  { namen_liste namen_aktuell "{}{ll}{, jj}{ f}" format.name$ " " * *
    namen_aktuell #1 + 'namen_aktuell := }
  while$
  "(" year ") " * * * sortify
}

FUNCTION { vorsortieren }				% add the title to the sort string
{ sortierlabel title sortify * 'sort.key$ := }		% and save it as the sort.key$

FUNCTION {initialize.extra.label.stuff}			% stolen from apalike
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}					% used to identify duplicate sort
{ last.label sortierlabel =				% strings; stolen from apalike
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      sortierlabel 'last.label :=
    }
  if$
}

FUNCTION {reverse.pass}					% used to generate extra labels
{ next.extra "b" =					% (a, b, etc.) for duplicate sort
    { "a" 'extra.label := }				% strings; stolen from apalike
    'skip$
  if$
  extra.label 'next.extra :=
}



%------------------------------------------------------- parsing the BibTeX fields

FUNCTION { autorennamen }				% re-arrange the author field
{ author 'namen_liste :=
  namen_liste num.names$ 'namen_gesamt :=
  namen_gesamt #1 - 'namen_uebrig :=
  namen_gesamt namen_uebrig - 'namen_aktuell :=
     namen_gesamt #2 <
    { "\textsc{" namen_liste namen_gesamt "{vv~}{ll}{, jj}{, f{.}.}" format.name$ "}" * * write$ newline$ }	%bei nur einem Namen ausfuehren
    { { namen_aktuell namen_gesamt < }
      { "\textsc{" namen_liste namen_aktuell "{vv~}{ll}{, jj}{, f{.}.}" format.name$ "}" * *	%bei mehreren Namen ausfuehren
        namen_aktuell namen_gesamt #1 - =	%if-Bedingung: Nach dem vorletzten Namen ein UND, sonst KOMMA
        {" u." *}
        {"," *}
        if$
        write$ newline$
        namen_aktuell #1 + 'namen_aktuell :=
       }
      while$
      "\textsc{" namen_liste namen_gesamt "{f{.}.~}{vv~}{ll}{, jj}" format.name$ "}" * * write$ newline$ }
    if$
}

FUNCTION { herausgeber }				% re-arrange the editor field
{ editor 'editor_liste :=
  editor_liste num.names$ 'editor_gesamt :=
  editor_gesamt #1 - 'editor_uebrig :=
  editor_gesamt editor_uebrig - 'editor_aktuell :=
     editor_gesamt #2 <
    { type$ "book" =
      {"\textsc{" editor_liste editor_gesamt "{vv~}{ll}{, jj}{, f{.}.}" format.name$ "} (Hrsg.)" * * write$ newline$ }
      {"\textsc{" editor_liste editor_gesamt "{vv~}{ll}{, jj}{, f{.}.}" format.name$ "} (Hrsg.):" * * write$ newline$ }
      if$
    }
    { { editor_aktuell editor_gesamt < }
      { "\textsc{" editor_liste editor_aktuell "{vv~}{ll}{, jj}{, f{.}.}" format.name$ "}" * *
        editor_aktuell editor_gesamt #1 - =
        {" u." *}
        {"," *}
        if$
        write$ newline$
        editor_aktuell #1 + 'editor_aktuell :=
       }
      while$
      author empty$
      { "\textsc{" editor_liste editor_gesamt "{f{.}.~}{vv~}{ll}{, jj}" format.name$ "} (Hrsg.)" * * write$ newline$ }
      { "\textsc{" editor_liste editor_gesamt "{f{.}.~}{vv~}{ll}{, jj}" format.name$ "} (Hrsg.):" * * write$ newline$ }
      if$
    }
    if$
}

FUNCTION { jahreszahl }					% put the year in parentheses,
{ edition empty$					% identify empty year fields and
  { year empty$						% add edition as superscript
    { "(o.J.)" write$ newline$ }
    { "(" year extra.label "):" * * * write$ newline$ }
    if$ }
  { edition 'auflage :=
    year empty$
    { "(o.J.$^{" auflage "}$)" * * write$ newline$ }
    { "(" year extra.label "$^{" auflage "}$):" * * * * * write$ newline$ }
    if$ }
  if$
}

FUNCTION { titel }					% title field; check if sentence
{ title #-1 #1 substring$ "}" =
  { title #-2 #1 substring$ "?" =
    { title write$ newline$ }
    { title #-2 #1 substring$ "!" =
      { title write$ newline$ }
      { title #-2 #1 substring$ "." =
        { title write$ newline$ }
        { title "." * write$ newline$ }
        if$
      }
      if$
    }
    if$
  }
  { title #-1 #1 substring$ "?" =
    { title write$ newline$ }
    { title #-1 #1 substring$ "!" =
      { title write$ newline$ }
      { title #-1 #1 substring$ "." =
        { title write$ newline$ }
        { title "." * write$ newline$ }
        if$
      }
      if$
    }
    if$
  }
  if$
}

FUNCTION { verlag }					% identify empty publisher and
{ publisher empty$					% address field; put publisher
  { address empty$					% in parentheses if present,
    { pages empty$					% then add address
      { "o.O." write$ newline$ }
      { "o.O.," write$ newline$ }
      if$
    }
    { pages empty$
      { address "." * write$ newline$ }
      { address "," * write$ newline$ }
      if$
    }
    if$
  }
  { address empty$
    { pages empty$
      { "(" publisher ") o.O." * * write$ newline$ }
      { "(" publisher ") o.O.," * * write$ newline$ }
      if$
    }
    { pages empty$
      { "(" publisher ") " address "." * * * * write$ newline$ }
      { "(" publisher ") " address "," * * * * write$ newline$ }
      if$
    }
    if$
  }
  if$
}

FUNCTION { url-adressen }				% add URL if present
{ URL empty$
  { skip$ }
  { "Abrufbar unter: " URL " (Datum: \today)." * * write$ newline$ }
  if$
}

FUNCTION { notizen }					% add notes field
{ note empty$
  { skip$ }
  { note "." * write$ newline$ }
  if$
}

FUNCTION { buchtitel }					% booktitle field
{ booktitle empty$
  { skip$ }
  { booktitle #-1 #1 substring$ "}" =
    { booktitle #-2 #1 substring$ "?" =
      { booktitle write$ newline$ }
      { booktitle #-2 #1 substring$ "!" =
        { booktitle write$ newline$ }
        { booktitle #-2 #1 substring$ "." =
          { booktitle write$ newline$ }
          { booktitle "." * write$ newline$ }
          if$
        }
        if$
      }
      if$
    }
    { booktitle #-1 #1 substring$ "?" =
      { booktitle write$ newline$ }
      { booktitle #-1 #1 substring$ "!" =
        { booktitle write$ newline$ }
        { booktitle #-1 #1 substring$ "." =
          { booktitle write$ newline$ }
          { booktitle "." * write$ newline$ }
          if$
        }
        if$
      }
      if$
    }
    if$
  }
 if$
}

FUNCTION { seitenzahlen }				% format number of pages
{ pages empty$
  { skip$ }
  { "S.~" pages "." * * write$ newline$ }
  if$
}

FUNCTION { kapitel }					% insert chapter (for inbook)
{ chapter empty$
  { pages empty$
    { skip$ }
    { seitenzahlen }
    if$
  }
  { pages empty$
    { "Kapitel " chapter "." * * write$ newline$ }
    { "Kapitel " chapter "," * * write$ newline$
      seitenzahlen
    }
    if$
  }
  if$
}

FUNCTION { zeitschrift }				% journal
{ journal write$ }

FUNCTION { nummer }					% volume, number and pages
{ number empty$
  { pages empty$
    { volume empty$
      { "." write$ newline$ }
      { " " volume "." * * write$ newline$ }
      if$
    }
    { volume empty$
      { " S.~" pages "." * * write$ newline$ }
      { " " volume ", S.~" pages "." * * * * write$ newline$ }
      if$
    }
    if$
  }
  { pages empty$
    { volume empty$
      { " " number "." * * write$ newline$ }
      { " " volume ", " number "." * * * * write$ newline$ }
      if$
    }
    { volume empty$
      { " " number ", S.~" pages "." * * * * write$ newline$ }
      { " " volume ", " number ", S.~" pages "." * * * * * * write$ newline$ }
      if$
    }
    if$
  }
  if$
}

FUNCTION { thesis }					% type and school for PhD and
{ type empty$						% master theses if empty
  { type$ "phdthesis" =
    { "Dissertation." write$ newline$  }
    { "Abschlussarbeit." write$ newline$ }
    if$
  }
  { type "." * write$ newline$ }
  if$
  school empty$
  { skip$ }
  { school "." * write$ newline$ }
  if$
}

FUNCTION { serie }
{ series empty$
  { skip$ }
  { volume empty$
    { number empty$
      { series "." * write$ newline$ }
      { series " " number "." * * * write$ newline$ }
      if$
    }
    { number empty$
      { series " " volume "." * * * write$ newline$ }
      { series " " volume ", " number "." * * * * * write$ newline$ }
      if$
    }
    if$
  }
  if$
}



%------------------------------------------------------- the bibliography environment

FUNCTION { warnung }					% show credits in the bibtex output
{ " This is the inofficial BibTeX style for the Geographic Institute of the University of Bonn, Germany (giub.bst). Please report any bugs at http://github.com/leifeld/GIUB-BibTeX." warning$ }

FUNCTION {begin.bib}					% begin bibliography
{ "% This bibliography was created using the inofficial BibTeX style for the" write$ newline$
  "% Geographic Institute of the University of Bonn, Germany (giub.bst). Please" write$ newline$
  "% report any bugs at http://github.com/leifeld/GIUB-BibTeX." write$ newline$ newline$
  "\begin{thebibliography}{9999}" write$ newline$
}

FUNCTION {end.bib}					% end bibliography
{ "\end{thebibliography}" write$ newline$
  "\endinput" write$ newline$
}

FUNCTION { bibeintrag }					% bib item incl. label and entry
{ "\bibitem[" zitationslabel "]{" cite$ "}" * * * * write$ newline$ }



%------------------------------------------------------- assemble bib items by call type

FUNCTION { book }
{ bibeintrag
  author empty$
    { herausgeber }
    { autorennamen }
    if$
  jahreszahl
  titel
  serie
  verlag
  url-adressen
  notizen
}

FUNCTION { incollection }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  "In: " write$ newline$
  editor empty$
  { skip$ }
  { herausgeber }
  if$
  buchtitel
  serie
  verlag
  seitenzahlen
  url-adressen
  notizen
}

FUNCTION { article }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  "In: " write$ newline$
  zeitschrift
  nummer
  url-adressen
  notizen
}

FUNCTION { phdthesis }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  thesis
  url-adressen
  notizen
}

FUNCTION { mastersthesis }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  thesis
  url-adressen
  notizen
}

FUNCTION { techreport }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  type empty$
  { number empty$
    { skip$ }
    { number "." * write$ newline$ }
    if$
  }
  { number empty$
    { type "." * write$ newline$ }
    { type " " number "." * * * write$ newline$ }
    if$
  }
  if$
  institution empty$
  { skip$ }
  { institution "." * write$ newline$ }
  if$
  url-adressen
  notizen
}

FUNCTION { inproceedings }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  editor empty$
  { skip$ }
  { herausgeber }
  if$
  buchtitel
  verlag
  seitenzahlen
  url-adressen
  notizen
}

FUNCTION { misc }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  howpublished empty$
  { skip$ }
  { howpublished "." * write$ newline$ }
  if$
  url-adressen
  notizen
}

FUNCTION { inbook }
{ bibeintrag
  author empty$
    { herausgeber }
    { autorennamen }
    if$
  jahreszahl
  titel
  serie
  verlag
  kapitel
  url-adressen
  notizen
}

FUNCTION { proceedings }
{ bibeintrag
  author empty$
    { herausgeber }
    { autorennamen }
    if$
  jahreszahl
  titel
  serie
  organization empty$
  { skip$ }
  { organization "." * write$ newline$ }
  if$
  verlag
  url-adressen
  notizen
}

FUNCTION { unpublished }
{ bibeintrag
  autorennamen
  jahreszahl
  titel
  type empty$
  { "Unver\^^b{o}ffentlichtes Manuskript." write$ newline$ }
  { type "." * write$ newline$ }
  if$
  notizen
}

FUNCTION {default.type}
{ book }



%------------------------------------------------------- execute and iterate functions

READ

EXECUTE { warnung }

ITERATE { vorsortieren }
SORT

EXECUTE {initialize.extra.label.stuff}

ITERATE {forward.pass}
REVERSE {reverse.pass}

EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}
