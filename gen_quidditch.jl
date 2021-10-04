using Random

function gen_quidditch(n_teams)

    # The names of all possible teams.
    all_teams = ["Appleby_Arrows      ",
                 "Ballycastle_Bats    ",
                 "Caerphilly_Catapults",
                 "Chudley_Cannons     ",
                 "Falmouth_Falcons    ",
                 "Holyhead_Harpies    ",
                 "Kenmare_Kestrels    ",
                 "Montrose_Magpies    ",
                 "Pride_of_Portree    ",
                 "Puddlemere_United   ",
                 "Tutshill_Tornados   ",
                 "Wigtown_Wanderers   ",
                 "Wimbourne_Wasps     "]

    # The total number of teams included in the division. (2 <= n <= 13)
    println(ARGS == String[])
    if ARGS == String[]
        n = 13
    else
        n = parse(Int, n_teams)
        if n > 13
            println("Number of teams is too large. It has been reduced to 13.")
            n = 13
        if n < 2
            println("Number of teams is too small. It has been increased to 2.")
            n = 2

    # Randomly select n teams from the list of 13.
    teams = shuffle(all_teams)[1:n]

    # Initialize the schedule matrix for 2 matches per match-up.
    A = zeros(Int, n, n)
    for i in 1:n
        for j in 1:n
            if i != j
                A[i, j] = 2
            end
        end
    end

    # Randomly assign a skill level to each team.
    chances = rand(n)

    # Initialize the wins and losses of each team at 0.
    wins = zeros(Int, n)
    losses = zeros(Int, n)

    # Simulate an outcome for each match and store the division standings.
    count = 0
    while sum(A) > 1e-9
        global count += 1
        # Randomly select a match from the remaining unplayed matches.
        games = findall(x->x>1e-9, A)
        game = rand(1:size(games)[1])
        t1 = games[game][1]
        t2 = games[game][2]
        # Determine the probability team 1 wins the match and decide a winner.
        prob = chances[t1] / (chances[t1] + chances[t2])
        r = rand()
        if r <= prob
            wins[t1] += 1
            losses[t2] += 1
        else
            wins[t2] += 1
            losses[t1] += 1
        end
        # Update the remaining match schedule.
        A[t1, t2] -= 1
        A[t2, t1] -= 1

        # Generate the division standings and store them in a text file.
        div = "# Team               Win Loss Left\n--------------------------------------------------\n"
        for i in 1:n
            div = div * string(i) * " " * teams[i] * " " * string(wins[i]) * "    " * string(losses[i]) * "   " * string(sum(A[i, :])) * " "
            for j in 1:n
                div = div * string(A[i, j]) * " "
            end
            div = div * "\n"
        end
        open("./quidditch_div/division_quid_" * string(count) * ".txt", "w") do text_file
            write(text_file, div)
        end
    end
end

gen_quidditch(ARGS[1])
