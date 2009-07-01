include ../config.mk

PROG = blink

PROGS = \
	blink \
	commstime \
	hello \
	nothing \
	rawblink \
	testdiv

all: $(addsuffix .hex,$(PROGS))

# Compile occam program.
%.hex: %.occ
	occbuild -v -DF.CPU=$(F_CPU) --program $<
	# FIXME: check OCCAMADDR doesn't overlap the TVM
	../binary-to-ihex $(OCCAMADDR) $(basename $<).tbc $@

AVRDUDE_WRITE_OCCAM = -D -U flash:w:$(PROG).hex

upload: $(PROG).hex
	../reset-arduino $(PORT)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_OCCAM)
	../read-arduino $(PORT)

clean:
	rm -f \
		$(addsuffix .tce,$(PROGS)) \
		$(addsuffix .tbc,$(PROGS)) \
		$(addsuffix .hex,$(PROGS))

#{{{ dependencies
avr.module: iom328p.inc
blink.hex: wiring.module
commstime.hex: wiring.module
hello.hex: wiring.module
testdiv.hex: wiring.module
rawblink.hex: wiring.module
wiring.module: avr.module
#}}}
