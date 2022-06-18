# to_do_list_julia_gtk
This is a code to test my abilityes in julia and Gtk.

To run this code, is necessary to install Julia compiler, 'Dates' and 'Gtk' libs.

To install a new lib, type into Julia console:
  using Pkg
  Pkg.add("lib name")

After installing Gtk, it is necessary to configure a new function to the Gtk lib. To do it, open Gtk/gen/gbox3 and type:
    function cb_remove_all(combo_box::Gtk.GtkComboBoxText)
        return ccall((:gtk_combo_box_text_remove_all, Gtk.libgtk), Ptr{UInt8}, (Ptr{Gtk.GObject},), combo_box)
    end

If all prerequisites are configured, to run it, got to the directory of this folder in terminal and run:
  julia to_do_gtk.jl

To edit activities list, change atividades.jl file!

Now, have fun!
