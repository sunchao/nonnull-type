.PHONY: all

SUBDIRS = library frac-nesting simple-concur permission-type
META = Makefile sources.cfg
GEN  = clsmap.elf methmap.elf fldmap.elf predmap.elf
HELP = clsmap-base.elf methmap-base.elf fldmap-base.elf predmap-base.elf
HAND = nonnull.elf subtype.elf typing.elf consistency.elf \
       consistency-thms.elf clsmap2predmap.elf clsmap2predmap-thms.elf \
       conversion.elf conversion-lemmas.elf conversion-thms.elf 
CSRC = clsmap.cpp fldmap.cpp methmap.cpp predmap.cpp

RELEASE = nonnull-type.tgz

CLEANFILES = ${GEN} ${SUBDIRS} ${RELEASE}
SRC = ${META} ${CSRC} ${HELP} ${HAND} 

all : ${SUBDIRS} ${SRC} ${GEN}

CAT = cat
# The C preprocessor (not C++ compiler!)
# Modify it if yours are not in the same path
CPP = /lib/cpp

CPPFLAGS = -DBEGIN_ELF="%}%" -DEND_ELF="%{%" -I../library 
REC = ../library/remove-empty-comments.pl
GN = ../library/get-names.pl

%.elf : %.cpp  %-base.elf
	${CPP} ${CPPFLAGS} $*.cpp | ${REC} > $$$$.elf; \
	${GN} $* $$$$.elf | ${CAT} $$$$.elf - > $*.elf; \
	rm $$$$.elf

MAPSRC = ../library/map-base.elf ../library/map-leq.elf 

VCI = /afs/cs.uwm.edu/users/csfac/boyland/cmd/vci
.PHONY: checkin checkout
checkin : 
	${VCI} ${SRC}
checkout :
	co ${SRC}

library :
	ln -s ../library library

simple-concur :
	ln -s ../simple-concur simple-concur

frac-nesting :
	ln -s ../frac-nesting frac-nesting

permission-type : 
	ln -s ../permission-type permission-type

${RELEASE} : README sources.cfg Makefile ${GEN}
	tar cvf - README sources.cfg `cat sources.cfg` | gzip > ${RELEASE}

clean : 
	rm -f ${CLEANFILES}

realclean : clean
	rcsclean
