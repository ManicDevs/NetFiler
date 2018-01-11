# Makefile
export OS = $(shell uname)
export CWD = $(shell pwd)

export LIB = $(CWD)/lib
export BIN = $(CWD)/bin
export OBJ = $(CWD)/obj

ifndef VERBOSE
.SILENT:
endif

default:
	@echo
	@echo " -: NetFiler Builder :-"
	@echo
	@echo " General build tasks¬"
	@echo "  make			-- Show this information"
	@echo "  make all		-- Build binary file(s)"
	@echo "  make client		-- Build client file(s)"
	@echo "  make server		-- Build server file(s)"
	@echo
	@echo " Administrative tasks¬"
	@echo "  make clean		-- Clean environment"
	@echo "  make clean-bin	-- Clean binary file(s)"
	@echo "  make clean-obj	-- Clean object file(s)"
	@echo "  make clean-deps 	-- Clean dependency file(s)"
	@echo

.PHONY: all
all: client server

client: client-linux-x86_64

server: server-linux-x86_64

client-linux-x86_64:
	@make -f Makefile.client-linux-x86_64 all

server-linux-x86_64:
	@make -f Makefile.server-linux-x86_64 all

linux-x86_64:
	@make -f Makefile.linux-x86_64 all

.PHONY: clean-obj
clean-obj:
	@rm -f obj/*.o
	@rm -f obj/*.md5

.PHONY: clean-bin
clean-bin:
	@rm -rf bin/netfiler-*

.PHONY: clean-lib
clean-lib:
	@rm -rf $(CWD)/lib/*.a

.PHONY: clean-deps
clean-deps: clean-lib
	@echo
	@echo " [-] Started clean for all dependencies"
	@echo " [-] Cleaning BUILD environment"
	@rm -rf $(CWD)/deps/build
	@echo " [+] Done cleaning BUILD environment"
	@echo " [+] Done clean for all dependencies"
	@echo

.PHONY: clean
clean: clean-obj clean-bin
	@echo
	@echo " [-] Started clean for all builds"
	@echo " [-] Cleaning netfiler"
	@make -C netfiler clean
	@echo " [+] Done cleaning netfiler"
	@echo
