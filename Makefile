.PHONY: all

SUBDIRS = library frac-nesting simple-concur permission-type
META = Makefile sources.cfg
GEN = clsmap.elf methmap.elf fldmap.elf predmap.elf 
HELP = clsmap-base.elf methmap-base.elf fldmap-base.elf predmap-base.elf
HAND = abbrev.elf nonnull.elf nulltp.elf subtype.elf predmap.elf methmap.elf \
			 fldmap.elf predmap.elf oflist.elf consistent.elf typing.elf \
			consistent-thms.elf clspred.elf clspred-lemmas.elf clspred-totality.elf \
			convert.elf convert-totality.elf permop-lemmas.elf convert-ok-thms.elf
CSRC = clsmap.cpp fldmap.cpp methmap.cpp predmap.cpp 

RELEASE = shared-fj.tgz

CLEANFILES = ${GEN} ${SUBDIRS} ${RELEASE}
SRC = ${META} ${CSRC} ${HELP} ${HAND} 

all : ${SUBDIRS} ${SRC} ${GEN}

CAT = cat
# The C preprocessor (not C++ compiler!)
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
