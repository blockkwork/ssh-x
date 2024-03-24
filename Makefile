OUT_PATH = ./zig-out/bin/sx 

BUILD:
	zig build
	sudo cp $(OUT_PATH) /bin/
RUN: 	
	zig build 
	./$(OUT_PATH) -l
ADD_SERVER:
	zig build 
	./$(OUT_PATH) -a swe root:pass@127.0.0.1:22