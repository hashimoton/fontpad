***************
fontpad
***************

Minimum text editor for trying a font(.ttf) before installation.

.. note:: For Ruby 2.x see fontpad2.rb_.

.. _fontpad2.rb: https://github.com/hashimoton/fontpad2
===========
PLATFORMS
===========

Works on Windows 7

==============
REQUIREMENTS
==============

Ruby 1.9.3

RubyGems: win32api, wxruby, ttfunk

============
SETUP
============

Copy fontpad.rb into your convenient directory.

============
USAGE
============

::
  
  > ruby fontpad.rb a_font_file.ttf


The default text in the editor is taken from the embeded sample in the font file or the font name
(in case no emeded sample).


===========
LICENSE
===========

Public Domain



.. EOF
