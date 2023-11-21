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
