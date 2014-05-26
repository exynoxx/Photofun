/*
	This file is part of Photofun: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
 * PhotoFun 0.3.1
 * author: Nicholas Tjornelund
 * 
 * Compiles with:
 * valac --pkg clutter-gtk-1.0 *.vala -o photofun
 * or
 * make
 */
public void main (string[] args)
{
	var err = GtkClutter.init (ref args);
	if (err != Clutter.InitError.SUCCESS)
	{
		error ("Clutter initialization failed");
	}
	window win = new window();
	win.show_all();
	Gtk.main();
}
