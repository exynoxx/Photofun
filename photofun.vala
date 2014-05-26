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

public class photofun : GtkClutter.Embed
{
	Clutter.Stage stage;
	Clutter.Actor actor;
	Gdk.Pixbuf pixbuf;
	Gdk.Pixbuf _pixbuf;
	Clutter.AlignConstraint constraint_y;
	
	float size_width;
	float size_height;
	float width_default;
	float height_default;
	double angle_x;
	double angle_y;
	double angle_z;
	float diff = 0.0f;
	public string animation_modes = "Expand";
	
	string[] filenames;
	int index = 0;
	int distance = 36;
	
	public photofun ()
	{		
		stage = get_stage () as Clutter.Stage;
		stage.show ();
		
		actor = new Clutter.Actor();
		constraint_y = new Clutter.AlignConstraint(stage, Clutter.AlignAxis.Y_AXIS, 0.5f);
	}
	public Clutter.Point center ()
	{
		Clutter.Point p;
		p = Clutter.Point.alloc();
		
		p.init(0.5f, 0.5f);
		
		return p;
	}
	public Gdk.Pixbuf get_icon (string filename)
	{
		try{
			_pixbuf = new Gdk.Pixbuf.from_file(filename);
		}catch(Error error){
			stdout.printf("Error: %s\n", error.message);
		}
		return _pixbuf;
	}
	public void open (Window parent)
	{
		var file_chooser = new FileChooserDialog ("Open File", 
							parent,
							FileChooserAction.OPEN, 
							"Cancel",
							ResponseType.CANCEL,
							"Open",
							ResponseType.ACCEPT);
							
		file_chooser.select_multiple = true;
		var filter = new Gtk.FileFilter ();
		filter.set_filter_name ("Images");
		filter.add_pattern ("*.png");
		filter.add_pattern ("*.jpg");
		filter.add_pattern ("*.bmp");
		file_chooser.add_filter (filter);
												  
		if (file_chooser.run () == ResponseType.ACCEPT) 
		{
			get_files(file_chooser.get_files ());
		}
		file_chooser.destroy ();
	}
	void get_files (SList<File> files)
	{
		filenames = null;
		
		foreach(var file in files)
		{
			filenames += file.get_path();
		}
		add_image(1);
	}
	void add_image (int direction)
	{
		stage.remove_all_children ();
		try{
			pixbuf = new Gdk.Pixbuf.from_file (filenames[index]);
		}catch(Error error){
			stdout.printf("Error: %s\n", error.message);
		}
		Clutter.Image img = new Clutter.Image ();
		img.set_data (pixbuf.get_pixels (),
				pixbuf.has_alpha 
				? Cogl.PixelFormat.RGBA_8888 
				: Cogl.PixelFormat.RGB_888,
				pixbuf.width,
				pixbuf.height,
				pixbuf.rowstride);
		actor.content = img;
		
		actor.pivot_point = center();
		if(!actor.has_constraints())
		{
			actor.add_constraint(constraint_y);
		}
		
		actor.set_size (50, 50);
		actor.rotation_angle_x = 0;
		actor.rotation_angle_y = 0;
		actor.rotation_angle_z = 0;
		angle_x = 0.0;
		angle_y = 0.0;
		angle_z = 0.0;
		
		size_width = pixbuf.width;
		size_height = pixbuf.height;
		diff = 0.0f;
		if(size_width > stage.width)
		{
			diff = stage.width / size_width;
			size_width = size_width * diff;
			size_height = size_height * diff;
		}
		if(size_height > stage.height)
		{
			diff = stage.height / size_height;
			size_width = size_width * diff;
			size_height = size_height * diff;
		}
		width_default = size_width;
		height_default = size_height;

		stage.add(actor);
		switch(animation_modes)
		{
			case "Expand":
				animate(actor, direction, "Expand");
				break;
			case "Zoom":
				animate(actor, direction, "Zoom");
				break;
			case "Slide":
				animate(actor, direction, "Slide");
				break;
		}
	}
	void animate(Clutter.Actor actor, int direction, string mode)
	{
		if(mode == "Expand")
		{
			if(direction == 1)
			{
				actor.set_position(stage.width, 0);
				
				actor.save_easing_state();
				actor.set_easing_duration(800);
				actor.set_easing_mode(Clutter.AnimationMode.EASE_OUT_EXPO);
				actor.set_easing_delay(70);
				actor.set_size (size_width, size_height);
				actor.set_position((stage.width - size_width) / 2, 0);
				actor.restore_easing_state();
			}
			else{
				actor.set_position(0 - size_width, 0);
				
				actor.save_easing_state();
				actor.set_easing_duration(800);
				actor.set_easing_mode(Clutter.AnimationMode.EASE_OUT_EXPO);
				actor.set_easing_delay(70);
				actor.set_size (size_width, size_height);
				actor.set_position((stage.width - size_width) / 2, 0);
				actor.restore_easing_state();
			}
		}
		if(mode == "Zoom")
		{
		
			actor.set_position((stage.width - 50) / 2, 0);

			actor.save_easing_state();
			actor.set_easing_duration(800);
			actor.set_easing_mode(Clutter.AnimationMode.EASE_OUT_EXPO);
			actor.set_size (size_width, size_height);
			actor.set_position((stage.width - size_width) / 2, 0);
			actor.restore_easing_state();
		
		}
		if(mode == "Slide")
		{			
			if(direction == 1)
			{
				actor.set_position(stage.width, 0);
				actor.set_size (size_width, size_height);
				
				actor.save_easing_state();
				actor.set_easing_duration(800);
				actor.set_easing_mode(Clutter.AnimationMode.EASE_OUT_EXPO);
				actor.set_position((stage.width - size_width) / 2, 0);
				actor.restore_easing_state();
				
			}
			else 
			{
				actor.set_position(0 - size_width, 0);
				actor.set_size (size_width, size_height);
				
				actor.save_easing_state();
				actor.set_easing_duration(800);
				actor.set_easing_mode(Clutter.AnimationMode.EASE_OUT_EXPO);
				actor.set_position((stage.width - size_width) / 2, 0);
				actor.restore_easing_state();
			}
		}
	}
	public void next (bool left)
	{
		if(left == true)
		{
			index++;
			if(index > filenames.length -1)
			{
				index = 0;
			}
			add_image(1);
		}
		else
		{
			index--;
			if(index < 0)
			{
				index = filenames.length -1;
			}
			add_image(2);
		}
	}
	public void rotate_x(bool rotateleft)
	{
		actor.save_easing_state();
		actor.set_easing_duration(500);
		if(rotateleft == true)
		{
			angle_x -= distance;
			actor.rotation_angle_x = angle_x;
		}
		else
		{
			angle_x += distance;
			actor.rotation_angle_x = angle_x;
		}
		actor.restore_easing_state();	
	}
	public void rotate_y(bool rotateleft)
	{
		actor.save_easing_state();
		actor.set_easing_duration(500);
		if(rotateleft == true)
		{
			angle_y += distance;
			actor.rotation_angle_y = angle_y;
		}
		else
		{
			angle_y -= distance;
			actor.rotation_angle_y = angle_y;
		}
		actor.restore_easing_state();	
	}
	public void rotate_z(bool rotateleft)
	{
		actor.save_easing_state();
		actor.set_easing_duration(500);
		if(rotateleft == true)
		{
			angle_z += distance;
			actor.rotation_angle_z = angle_z;
		}
		else
		{
			angle_z -= distance;
			actor.rotation_angle_z = angle_z;
		}
		actor.restore_easing_state();	
	}
	public void zoom (bool zoom)
	{
		actor.save_easing_state();
		actor.set_easing_duration(50);
		if(zoom == true)
		{
			size_width = size_width *= 1.1f;
			size_height = size_height *= 1.1f;
			actor.set_size(size_width, size_height);
			actor.set_position((stage.width - size_width) / 2, 0);
		}
		else
		{
			size_width = size_width /= 1.1f;
			size_height = size_height /= 1.1f;
			actor.set_size(size_width, size_height);
			actor.set_position((stage.width - size_width) / 2, 0);
		}
		actor.restore_easing_state();
	}
	public void reset ()
	{
		actor.save_easing_state();
		actor.set_easing_duration(1000);
		actor.rotation_angle_x = 0;
		actor.rotation_angle_y = 0;
		actor.rotation_angle_z = 0;
		angle_x = 0.0;
		angle_y = 0.0;
		angle_z = 0.0;
		actor.set_size (width_default, height_default);
		actor.set_position((stage.width - width_default) / 2, 0);
		actor.restore_easing_state();
		size_width = width_default;
		size_height = height_default;
	}
}
