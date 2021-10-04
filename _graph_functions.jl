using LightGraphs, LightGraphsFlows
using SparseArrays: spzeros

# Parse the division text file into required information
function read_division(div_name)

    # Read .txt files using open()
    open(div_name) do f
        lines = readlines(f)
        # Get the total number of teams.
        n = size(lines)[1] - 2
        # Initialize a list for the names of each team
        teams = []
        # Initialize a list for the records of each team
        games = []
        # Initialize a matrix for the number of individual remaining matches
        A = zeros(Int, n, n)
        
        for i in 1:n
            # Splitting each line into an array.
            line = split(lines[i+2])
            # Collect team names in an array.
            teams = [teams; [line[2]]]
            # Collect team wins, losses, and total games remaining in an array of tuples.
            games = [games; [(parse(Int, line[3]), parse(Int, line[4]), parse(Int, line[5]))]]
            
            # Collect individual remaining matches in a matrix.
            for j in 1:n
                A[i, j] = parse(Int, line[5+j])
            end

            # Check that a team is not scheduled to play themselves.
            if A[i, i] != 0
                throw(ArgumentError("A team cannot play itself. Check team " * teams[i] * "."))
            end

        end

        # Check that the individual remaining matches are well defined.
        if A != A'
            throw(ArgumentError("Matrix of remaining matches must be symmetric."))
        end

        return teams, games, A

    end
end

# Define the graph for the team of interest.
function define_graph(games, A, team, ub)

    # Calculate the maximum number of games the team of interest can win.
    max_team_win = games[team][1] + games[team][3]

    # Get the number of teams.
    n = size(games)[1]
    # Calculate the number of possible matches
    n_match = ((n - 2) * (n - 1)) ÷ 2

    # Initialize the DiGraph using LightGraphs
    # Source + all possible matches + each team + sink = # of nodes
    flow_graph = LightGraphs.DiGraph(n_match + n + 1)
    
    # Initialize nxn capacity matrix
    capacity_matrix = spzeros(Int, n_match + n + 1, n_match + n + 1)

    # Counts used to account for skipping the team of interest index
    count = 1
    count2 = 0
    for i in Iterators.flatten((1:(team-1), (team+1):(n-1)))
        count2 += 1
        count3 = count2
        for j in Iterators.flatten(((i+1):(team-1), (max(team, i)+1):n))
            count += 1
            count3 += 1 
            # Connect the source to the individual match nodes
            LightGraphs.add_edge!(flow_graph, 1, count)
            capacity_matrix[1, count] = A[i, j]
            
            # Connect the individual match nodes to their respective team nodes
            LightGraphs.add_edge!(flow_graph, count, 1 + n_match + count2)
            capacity_matrix[count, 1 + n_match + count2] = ub
            LightGraphs.add_edge!(flow_graph, count, 1 + n_match + count3)
            capacity_matrix[count, 1 + n_match + count3] = ub
        end
        # Connect the team nodes to the sink
        LightGraphs.add_edge!(flow_graph, 1 + n_match + count2, 1 + n_match + n)
        capacity_matrix[1 + n_match + count2, 1 + n_match + n] = max_team_win - games[i][1]
    end
    # Need to account for final team node missed by the for loop (only if team of interest index is not n)
    if team != n
        LightGraphs.add_edge!(flow_graph, n_match + n, 1 + n_match + n)
        capacity_matrix[n_match + n, 1 + n_match + n] = max(max_team_win - games[n][1], 0)
    end

    return flow_graph, capacity_matrix

end
