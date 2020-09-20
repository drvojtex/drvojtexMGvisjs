using DataStructures, GraphPlot

function create_graph_database(graph::Any)

    if isfile("graph_database.js")
        run(`rm graph_database.js`)
    end
    run(`touch graph_database.js`)

    graph_file = open("graph_database.js", "w")

    print(graph_file, string("var graph_edges = ["))

    added_pairs = Stack{Any}()
    
    for (i, vertex) in enumerate(collect(keys(graph.vprops)))
        neighbours = neighbors(graph, vertex)
        for (j, neighbour) in enumerate(neighbours)
            if Pair(vertex, neighbour) ∉ added_pairs && Pair(neighbour, vertex) ∉ added_pairs
                push!(added_pairs, Pair(vertex, neighbour))
            end
        end
    end
    while !isempty(added_pairs)
        edge = pop!(added_pairs)
        if isempty(added_pairs)
            println(graph_file, string("{from: ", edge[1], ", to: ", edge[2], "}];"))
        else
            print(graph_file, string("{from: ", edge[1], ", to: ", edge[2], "},"))
        end
    end

    ##############################


    print(graph_file, string("var graph_nodes = ["))

    #nlist = [collect(i*20-19:i*20) for i=1:(Int(floor(length(vertices_arr)/20))+20)]
    x, y = shell_layout(graph)
    x*=50
    y*=50

    for (i, vertex) in enumerate(collect(keys(graph.vprops)))
        v_info = props(graph, vertex)
        msg = string("{id: ", vertex, ", label: '", vertex ,"', title: '<b>name:</b> ", string(v_info[:name]), "', x:", x[i], ", y:", y[i], ", color: {border: '", v_info[:colour], "', background: ", "'#999DA0", "'}}")
        if i!=length(collect(keys(graph.vprops)))
            print(graph_file, string(msg, ","))
        else
            print(graph_file, string(msg, "];"))
        end
    end

    close(graph_file)
end
