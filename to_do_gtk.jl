using Gtk
using Gtk.ShortNames, Gtk.GConstants, Gtk.Graphics
import Gtk.deleteat!, Gtk.libgtk_version, Gtk.GtkToolbarStyle, Gtk.GtkFileChooserAction, Gtk.GtkResponseType
using Dates
include("atividades.jl")

get_date_string() = string(today())
clear_terminal() = run(`cmd /c cls`)

function set_combo_box_itens(combo_box, activities_vector)
    GAccessor.cb_remove_all(combo_box)
    num_of_itens = length(activities_vector)
    for choice in activities_vector
        push!(combo_box,choice)
    end 
    return num_of_itens
end


function build_activities_window()
    g = GtkGrid()

    not_done_box = GtkTextView()
    not_done_buffer = GAccessor.buffer(not_done_box)
    done_box = GtkTextView()
    done_buffer = GAccessor.buffer(done_box)
    GAccessor.size_request(not_done_box,0,200)
    GAccessor.size_request(done_box,0,200)

    date_label = GtkLabel("date_label")
    done_label = GtkLabel("done_label")
    not_done_label = GtkLabel("not_done_label")
    GAccessor.markup(date_label,"Executando dia "*get_date_string())
    GAccessor.markup(done_label,"Atividades realizadas")
    GAccessor.markup(not_done_label,"Atividades não realizadas")
    GAccessor.selectable(date_label,true)
    GAccessor.selectable(done_label,true)
    GAccessor.selectable(not_done_label,true)
    GAccessor.justify(date_label,Gtk.GConstants.GtkJustification.CENTER)
    GAccessor.justify(done_label,Gtk.GConstants.GtkJustification.RIGHT)
    GAccessor.justify(not_done_label,Gtk.GConstants.GtkJustification.RIGHT)

    cb = GtkComboBoxText()
    cb2 = GtkComboBoxText()
    for choice in atividades_vec
        push!(cb,choice)
    end  
    b = GtkButton("Print das atividades do dia")
    exit_b = GtkButton("exit")
    change_b = GtkButton("Mudar status")

    ####################### 
    ## Defining a new grid to put into a window
    #######################
    g[1:4,1] = b
    g[1:4,2] = cb
    g[1:2,3] = not_done_label
    g[3:4,3] = done_label
    g[1:2,4] = not_done_box
    g[3:4,4] = done_box
    g[1:2,5] = cb2
    g[3:4,5] = change_b
    g[1,6] = date_label
    g[4,6] = exit_b

    set_gtk_property!(g, :column_homogeneous, true)
    set_gtk_property!(g, :column_spacing, 15)

    win = GtkWindow("main Window")

    push!(win, g)


    num_of_items = 0

    signal_connect(change_b, "clicked") do widget, others...
        idx = get_gtk_property(cb2, "active", Int)
        if idx >= num_of_items || idx < 0
            set_gtk_property!(cb2,:active,0)
        else
            str_turno = Gtk.bytestring( GAccessor.active_text(cb) )
            str_atividade = Gtk.bytestring( GAccessor.active_text(cb2) )
            change_status(str_turno, str_atividade)

            if num_of_items == (idx+1)
                set_gtk_property!(cb2,:active,0)
            else
                set_gtk_property!(cb2,:active,idx+1)
            end

            show_activities(str_turno)
        end
    end

    signal_connect(cb, "changed") do widget, others...
        turno = Gtk.bytestring( GAccessor.active_text(cb) )

        num_of_items = set_combo_box_itens(cb2, collect(keys(atividades[turno])))
        # GAccessor.cb_remove_all(cb2)
        # num_of_items = 0
        # for choice in collect(keys(atividades[turno]))
        # num_of_items = num_of_items + 1
        # push!(cb2,choice)
        # end
        set_gtk_property!(cb2,:active,0)
        show_activities(turno)
    end

    function show_activities(turno)
        done_str, not_done_str = get_activities(turno)
        GAccessor.text(done_buffer, done_str, -1)
        GAccessor.text(not_done_buffer, not_done_str, -1)
    end

    function print_tarefas(w)
        clear_terminal()
        print_dict()
    end
    signal_connect(print_tarefas, b, "clicked")

    function exit_function(w)
        destroy(win)
    end
    signal_connect(exit_function, exit_b, "clicked")

    return win
end
  
if !isinteractive()

win = build_activities_window()

showall(win)
c = Condition()
signal_connect(win, :destroy) do widget
    notify(c)
end
wait(c)

end
  