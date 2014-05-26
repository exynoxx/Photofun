default:
	valac --pkg clutter-gtk-1.0 *.vala -o photofun
	
run:
	./photofun
	
andrun:
	valac --pkg clutter-gtk-1.0 *.vala -o photofun --disable-warnings && ./photofun
	
c:
	valac --pkg clutter-gtk-1.0 -C *.vala
	
install:
	cp photofun /usr/bin
