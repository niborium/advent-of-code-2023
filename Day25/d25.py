import networkx as nx

def read_graph_from_file(file_path):
    graph = nx.Graph()
    with open(file_path) as file:
        for line in file:
            left, right = map(str.strip, line.split(":"))
            nodes = right.split()
            for node in nodes:
                graph.add_edge(left, node)
    return graph

def calculate_product_of_component_sizes(graph):
    graph.remove_edges_from(nx.minimum_edge_cut(graph))
    components = list(nx.connected_components(graph))
    return len(components[0]) * len(components[1])

if __name__ == "__main__":
    input_file_path = 'input.txt'
    graph = read_graph_from_file(input_file_path)
    result = calculate_product_of_component_sizes(graph)
    print(result)
