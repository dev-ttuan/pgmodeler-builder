.PHONY: setup start stop

setup:
	@chmod +x setup.sh
	@./setup.sh

start:
	@chmod +x start.sh
	@./start.sh

stop:
	@chmod +x stop.sh
	@./stop.sh
