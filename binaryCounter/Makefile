PROGRAM=counter
CONSTRAINTS=pins
BOARD=tangnano20k
FAMILY=GW2A-18C
DEVICE=GW2AR-LV18QN88C8

default:
	yosys -q \
	  -p "synth_gowin -top $(PROGRAM) -json $(PROGRAM).json" \
	  $(PROGRAM).v
	nextpnr-himbaechel -r \
	  --json $(PROGRAM).json \
	  --write $(PROGRAM)_pnr.json \
	  --freq 27 \
	  --vopt family=$(FAMILY) \
	  --vopt cst=$(pins).csv \
	  --device $(DEVICE)
	gowin_pack -d $(DEVICE) -o $(PROGRAM).fs $(PROGRAM)_pnr.json

load:
	openFpgaLoader -b $(BOARD) $(PROGRAM).fs

build-flash: default load
