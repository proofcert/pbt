# Modify the path to the Teyjus executables as needed
# TEYJUS=/home/alberto/REPS/gits/teyjus
TEYJUS=/usr/local/bin

# .PHONY: all interp kernel fpcs test-lst
# all: interp kernel fpcs test-lst

# Everything after this point is generic and should be duplicated
# in user's makefiles

.PHONY: all
all: counter.lp cr.lp lists.lp

%.lpo : %.mod %.sig
	$(TEYJUS)/tjcc $*


-include depend
depend: *.mod *.sig
	$(TEYJUS)/tjdepend *.mod > depend-stage
	mv depend-stage depend

%.lp : %.lpo
	$(TEYJUS)/tjlink $*


.PHONY: clean
clean:
	rm -f *.lpo *.lp depend
