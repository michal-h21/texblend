# TeXBlend - Compile Segments of LaTeX Documents

This tool compiles individual files that are included as parts of larger
documents. It utilizes the preamble of the main document but disregards all
other included files.

The main purpose is to allow fast compilation of particular chapters or
sections, eliminating the need to recompile the entire document. This
facilitates an efficient way to check for formatting or syntax errors in the
particular part of the document being worked on.

## Documentation

The documentation is automatically created from TeX sources. 
You can see it [here](https://www.kodymirus.cz/texblend/).

## Install

The `texblend` command is self-contained, you can just copy it to a directory
in the path where your system looks for commands. On Linux, this could be for example
`$HOME/.local/bin/`. If this directory exists on your system, you can also try
the `make install` command, which will put the script there automatically.

## License

Copyright: 2023 Michal Hoftich

This work may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3
of this license or (at your option) any later version.
The latest version of this license is in
  http://www.latex-project.org/lppl.txt
and version 1.3 or later is part of all distributions of LaTeX
version 2005/12/01 or later.

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michal Hoftich.
