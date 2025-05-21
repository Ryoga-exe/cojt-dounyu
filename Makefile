VERYL = veryl
VIVADO = vivado

build:
	$(VERYL) build

test:
	$(VERYL) test

vivado:
	$(VIVADO) -mode batch -source script/vivado.tcl -nolog -nojournal

clean:
	$(VERYL) clean
	rm -rf project .Xil *.xpr
