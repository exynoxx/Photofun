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
using Gtk;

public class window : Window
{
	ToolButton button_open;
	ToolButton button_undo;
	ToolButton button_redo;
	ToolButton button_zoom;
	ToolButton button_zoomout;
	ToolButton button_reset;
	ToolButton button_left;
	ToolButton button_right;
	ToolButton button_up;
	ToolButton button_down;
	ToolButton button_next;
	ToolButton button_prev;
	ListStore list_store;
	TreeIter iter;
	ToolItem item;
	Window window;
	
	public window ()
	{
		window = this;
		photofun photo = new photofun ();
		this.title = "PhotoFun 0.3.1";
		this.set_default_size(800, 500);
		this.window_position = Gtk.WindowPosition.CENTER;
		this.set_icon(photo.get_icon("app.png"));
		this.destroy.connect(Gtk.main_quit);
		
		var box = new Box (Orientation.VERTICAL, 0);
		var toolbar = new Toolbar ();
		toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
		
		var seperator1 = new SeparatorToolItem ();
		var seperator2 = new SeparatorToolItem ();
		var seperator3 = new SeparatorToolItem ();
		var seperator4 = new SeparatorToolItem ();
		var seperator5 = new SeparatorToolItem ();
		var seperator6 = new SeparatorToolItem ();
		var seperator7 = new SeparatorToolItem ();

		var open = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.SMALL_TOOLBAR);
		var left = new Gtk.Image.from_icon_name ("go-previous", Gtk.IconSize.SMALL_TOOLBAR);
		var right  = new Gtk.Image.from_icon_name ("go-next", Gtk.IconSize.SMALL_TOOLBAR);
		var up = new Gtk.Image.from_icon_name ("go-up", Gtk.IconSize.SMALL_TOOLBAR);
		var down = new Gtk.Image.from_icon_name ("go-down", Gtk.IconSize.SMALL_TOOLBAR);
		var undo = new Gtk.Image.from_icon_name ("edit-undo", Gtk.IconSize.SMALL_TOOLBAR);
		var redo = new Gtk.Image.from_icon_name ("edit-redo", Gtk.IconSize.SMALL_TOOLBAR);
		var zoom = new Gtk.Image.from_icon_name ("zoom-in", Gtk.IconSize.SMALL_TOOLBAR);
		var zoomout = new Gtk.Image.from_icon_name ("zoom-out", Gtk.IconSize.SMALL_TOOLBAR);
		var cancel = new Gtk.Image.from_icon_name ("window-close", Gtk.IconSize.SMALL_TOOLBAR);
		var next = new Gtk.Image.from_icon_name ("go-first", Gtk.IconSize.SMALL_TOOLBAR);
		var prev = new Gtk.Image.from_icon_name ("go-last", Gtk.IconSize.SMALL_TOOLBAR);

		button_open = new ToolButton(open, null);
		button_up = new ToolButton(up, null);
		button_down = new ToolButton(down, null);
		button_undo = new ToolButton(undo, null);
		button_redo = new ToolButton(redo, null);
		button_left = new ToolButton(left, null);
		button_right = new ToolButton(right, null);
		button_zoom = new ToolButton(zoom, null);
		button_zoomout = new ToolButton(zoomout, null);
		button_reset = new ToolButton(cancel, null);
		button_next = new ToolButton(next, null);
		button_prev = new ToolButton(prev, null);
		item = new ToolItem();	
		item.set_expand(true);
		
		list_store = new ListStore (1, typeof (string));
		list_store.append (out iter);
		list_store.set (iter, 0,"Expand");
		list_store.append (out iter);
		list_store.set (iter, 0,"Zoom");
		list_store.append (out iter);
		list_store.set (iter, 0,"Slide");

		ComboBox combo = new ComboBox.with_model (list_store);

		CellRendererText renderer = new CellRendererText ();
		combo.pack_start (renderer, true);
		combo.add_attribute (renderer, "text", 0);
		combo.active = 0;

		combo.changed.connect (() => {
			Value val;

			combo.get_active_iter (out iter);
			list_store.get_value (iter, 0, out val);

			photo.animation_modes = (string) val;
		});
		item.child = combo;
		
		toolbar.add(button_open);
		toolbar.add(seperator1);
		toolbar.add(button_undo);
		toolbar.add(button_redo);
		toolbar.add(seperator2);
		toolbar.add(button_up);
		toolbar.add(button_down);
		toolbar.add(seperator3);
		toolbar.add(button_left);
		toolbar.add(button_right);
		toolbar.add(seperator4);
		toolbar.add(button_zoom);
		toolbar.add(button_zoomout);
		toolbar.add(seperator5);
		toolbar.add(button_reset);
		toolbar.add(seperator6);
		toolbar.add(button_next);
		toolbar.add(button_prev);
		toolbar.add(seperator7);
		toolbar.add(item);
		
		box.pack_start(toolbar, false);
		box.pack_start(photo);
		
		this.add(box);
		
		button_open.clicked.connect(() => photo.open(window));
		button_up.clicked.connect(() => photo.rotate_x(false));
		button_down.clicked.connect(() => photo.rotate_x(true));
		button_undo.clicked.connect(() => photo.rotate_z(false));
		button_redo.clicked.connect(() => photo.rotate_z(true));
		button_left.clicked.connect(() => photo.rotate_y(false));
		button_right.clicked.connect(() => photo.rotate_y(true));
		button_zoom.clicked.connect(() => photo.zoom(true));
		button_zoomout.clicked.connect(() => photo.zoom(false));
		button_reset.clicked.connect(() => photo.reset());
		button_next.clicked.connect(() => photo.next(false));
		button_prev.clicked.connect(() => photo.next(true));
	}
}
