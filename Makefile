LOG_FILE := tmp/emulator.log

# Inject --vnc if PEBBLE_VNC is set
ifdef PEBBLE_VNC
VNC := --vnc
else
VNC :=
endif

# Build the app, both C & PKJS
.PHONY: build
build:
	pebble build || pebble build

.PHONY: shutdown_emulator
shutdown_emulator:
	-pebble kill
	pebble wipe

.PHONY: start_emulator
start_emulator: shutdown_emulator
	mkdir -p tmp
	pebble logs --emulator=emery $(VNC) > $(LOG_FILE) 2>&1 &
	@echo "Emulator starting, logs -> $(LOG_FILE)"
ifndef PEBBLE_VNC
	@sleep 3 && osascript \
		-e 'tell application "System Events" to set frontmost of (first process whose name contains "qemu") to true' &
endif

# Install the app on emulators
.PHONY: install_emulator_aplite install_emulator_basalt install_emulator_chalk install_emulator_diorite install_emulator_emery

install_emulator_aplite:
	pebble install --emulator=aplite $(VNC)

install_emulator_basalt:
	pebble install --emulator=basalt $(VNC)

install_emulator_chalk:
	pebble install --emulator=chalk $(VNC)

install_emulator_diorite:
	pebble install --emulator=diorite $(VNC)

install_emulator_emery:
	pebble install --emulator=emery $(VNC)

# Install the app on your watch
.PHONY: install_cloudpebble
install_cloudpebble:
	pebble install --cloudpebble

# Clean build artifacts
.PHONY: clean
clean:
	pebble clean
