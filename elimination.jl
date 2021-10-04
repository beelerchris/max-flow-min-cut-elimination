include("_graph_functions.jl")

# Name of the file containing the division information

if division == String[]
    division = "./divisions/division_1.txt"
end

# Parse divinsion information into useful information
teams, games, A = read_division(division)

# Get the number of teams
n = size(teams)[1]

for i in 1:n
    # Create a graph and capacity matrix for Team i.
    flow_graph, capacity_matrix = define_graph(games, A, i, 1000)
    n_nodes = size(capacity_matrix)[1]
    teams_1 = collect(Iterators.flatten((1:(i-1), (i+1):n)))
    elim_check = true
    # Check if any team already has more wins than Team i can attain.
    all_wins = collect(games[j][1] for j in Iterators.flatten((1:(i-1), (i+1):n)))
    if (games[i][1] + games[i][3]) < max(all_wins...)
        elim_check = false
        win_max = maximum(all_wins)
        win_team = teams_1[findall(x->x==win_max, all_wins)[1]]
        println(teams[i] * " is eliminated.")
        println("They can win at most " * string(games[i][1]) * " + " * string(games[i][3]) * " = " * string(games[i][1] + games[i][3]) * " games.")
        println(teams[win_team] * " has already won " * string(win_max) * " games.")
        println(" ")
    end

    # If not, find the min-cut of Team i's graph.
    if elim_check
        part1, part2, v = LightGraphsFlows.mincut(flow_graph, 1, n_nodes, capacity_matrix, BoykovKolmogorovAlgorithm())
        cut_teams = []
        # Check which teams are in part 1 (the source side).
        for j in 1:(size(part1)[1] - 1)
            if part1[j+1] > (n_nodes - n)
                team_ind = teams_1[part1[j+1] + n - n_nodes]
                cut_team = (teams[team_ind], team_ind)
                cut_teams = [cut_teams; cut_team]
            end
        end

        # Create the certificate of elimination if required.
        if size(part1)[1] > 1
            println(teams[i] * " is eliminated.")
            println("They can win at most " * string(games[i][1]) * " + " * string(games[i][3]) * " = " * string(games[i][1] + games[i][3]) * " games.")
            reason = cut_teams[1][1]
            local wins = games[cut_teams[1][2]][1]
            for j in 2:size(cut_teams)[1]
                reason = reason * " and " * cut_teams[j][1]
                wins += games[cut_teams[j][2]][1]
            end
            println(reason * " have won a total of " * string(wins) * " games.")
            local n_matches = 0
            for j in 1:size(cut_teams)[1]
                for k in (j+1):size(cut_teams)[1]
                    n_matches += A[cut_teams[j][2], cut_teams[k][2]]
                end
            end
            # Determine if we round the average wins up or not.
            rem = (wins + n_matches) / size(cut_teams)[1] - (wins + n_matches) ÷ size(cut_teams)[1]
            if rem > 1e-9
                rem2 = 1
            else
                rem2 = 0
            end
            println("They play each other " * string(n_matches) * " times.")
            println("On average, each of the teams in this group wins " * string(wins + n_matches) * " / " * string(size(cut_teams)[1]) * " = " * string(round((wins + n_matches) / size(cut_teams)[1], digits=2)) * " games.")
            println("Therefore one team will win at least " * string((wins + n_matches) ÷ size(cut_teams)[1] + rem2) * " games.")
            println(" ")
        end
    end
end
