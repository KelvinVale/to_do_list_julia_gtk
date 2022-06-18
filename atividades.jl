COR_BRANCO           = "\u001b[38;5;231m"
COR_BRANCO_BRILHANTE = "\u001b[37;1m"
COR_PRETO            = "\u001b[38;5;232m"
COR_AZUL             = "\u001b[34;1m"
COR_VERMELHO         = "\u001b[31;1m"
COR_VERDE            = "\u001b[32;1m"

COR_FUNDO_CIANO      = "\u001b[46;1m"
COR_FUNDO_AZUL_CLARO = "\u001b[48;5;12m"
COR_FUNDO_VERM_CLARO = "\u001b[48;5;9m"
COR_FUNDO_VERDE_BRIL = "\u001b[42;1m"
COR_FUNDO_VERMELHO   = "\u001b[41m"
COR_FUNDO_CINZA      = "\u001b[48;5;244m"

COR_NEGRITO    = "\u001b[1m"
COR_SUBLINHADO = "\u001b[4m"

COR_RESETALL = "\u001b[0m"


atividades = Dict(
    "Turno1" => Dict("Atividade1"=>true, "Atividade2"=>false, "Atividade3"=>false, "Atividade4"=>false),
    "Turno2" => Dict("Atividade1"=>false, "Atividade2"=>false, "Atividade3"=>false, "Atividade4"=>false, "Atividade5"=>false),
    "Turno3" => Dict("Atividade1"=>false, "Atividade2"=>false, "Atividade3"=>false, "Atividade4"=>false, "Atividade5"=>false, "Atividade6"=>false, "Atividade7"=>false, "Atividade8"=>false, "Atividade9"=>false, "AtividadeN"=>false),
    "Turno4" => Dict("Atividade1"=>false, "Atividade2"=>false, "Atividade3"=>false)
)
tradutor = Dict(false => "Ainda não realizada", true => "Tarefa concluída")

atividades_vec = ["Turno1", "Turno2", "Turno3", "Turno4"]

function print_dict()
    for turno in atividades_vec
        tarefas = atividades[turno]
        println("Atividades do turno", COR_VERMELHO, " $turno:", COR_RESETALL)
        for atividade in tarefas
            nome_atividade, status = atividade
            if status
                str_aux = COR_VERDE
            else
                str_aux = COR_AZUL
            end
            status = tradutor[status]

            println("\t$nome_atividade - ", str_aux, "$status", COR_RESETALL)
        end
    end
end

function get_activities(turno="")
    try
        done_str = ""
        not_done_str = ""
        tarefas = atividades[turno]
        for atividade in tarefas
            nome_atividade, status = atividade
            if status
                done_str = done_str * ". $nome_atividade\n"
            else
                not_done_str = not_done_str * ". $nome_atividade\n"
            end
        end
        return done_str, not_done_str
    catch
        return "", ""
        println("Turno $turno não existente no banco de dados")
    end
end

function change_status(turno, atividade)
    if atividades[turno][atividade]
        atividades[turno][atividade] = false
    else
        atividades[turno][atividade] = true
    end
end
