FOSWIKI_ROOT?=~/foswiki/trunk/core
TARGET=gmap3.js 

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

gmap3.uncompressed.js: git/gmap3.js
	@echo copying $< to $@ 
	@cp $< $@
