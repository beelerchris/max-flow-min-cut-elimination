# Max-flow Min-cut Baseball End-of-Season Elimination
A Julia implementation of the graph theory based max-flow min-cut baseball end-of-season elimination problem. This problem deals with determining when a baseball team is mathematically eliminated from a division, i.e. when it becomes impossible for them to finish in 1st place. A report on this project can be found at https://cbeeler.medium.com/max-flow-min-cut-and-baseball-end-of-season-elimination-41323d3dc6c4.

The file **_graph_functions.jl** never needs to be run. This file only contains functions which are imported by the other included files. To use this method on a specific division standing, the name of the text file which contains the division standing information must be specified as a command line argument when running **elimination.jl**. The two examples from this report are included in the files **./divisions/division_1.txt** and **./divisions/division_2.txt** respectively. If no command line argument is provided, **./divisions/division_1.txt** will be used. **elimination.jl** will output the certificate of elimination for each eliminated team. If there is no output from running this code then no teams are eliminated.

To run the Quidditch experiment from this report, the number of teams must be specified as a command line argument when running **gen_quidditch.jl** with the requirement 2 &leq; *n* &leq; 13 and *n* is an integer. If no command line argument is provided, *n*=13 will be used. Once **gen_quidditch.jl** has been run, all *n*(*n*-1) division standing text files will be stored in **./divisions/quidditch_div/** under the name **./divisions/division_quid_*i*.txt** for 1 &leq; *i* &leq; *n*(*n*-1). Next **elimination_quidditch.jl** can be run and will output the number of matches before they were eliminated and the certificate of elimination for each team which does not finish in first place. Note that this code will always output something unless all *n* teams finish the division tied for first place. To use a specific set of Quidditch divisions, the path to a directory containing **division_quid_*i*.txt** files can be specified as a command line argument when running **elimination_quidditch.jl**.

Alternatively, the number of teams can be specified when running **main_quidditch.jl** which will sequentially run **gen_quidditch.jl** and **elimination_quidditch.jl**.

## Default Divisions

### Division 1

|#|Team        |Wins|Loss|Left|Atl|Phi|NY |Mon|
|-|------------|----|----|----|---|---|---|---|
|1|Atlanta     |83  |71  |8   |0  |1  |6  |1  |
|2|Philadelphia|80  |79  |3   |1  |0  |0  |2  |
|3|New York    |78  |78  |6   |6  |0  |0  |0  |
|4|Montreal    |77  |82  |3   |1  |2  |0  |0  |

Stored in **./divisions/division_1.txt**

### Division 2

|#|Team        |Wins|Loss|Left|NY |Bal|Bos|Tor|Det|
|-|------------|----|----|----|---|---|---|---|---|
|0|New York    |75  |59  |28  |0  |3  |8  |7  |3  |
|1|Baltimore   |71  |63  |28  |3  |0  |2  |7  |4  |
|2|Boston      |69  |66  |27  |8  |2  |0  |0  |0  |
|3|Toronto     |63  |72  |27  |7  |7  |0  |0  |0  |
|4|Detroit     |49  |86  |27  |3  |4  |0  |0  |0  |

Stored in **./divisions/division_2.txt**

## Examples

### Elimination Certificate for Division 1

    >> julia elimination.jl
    Philadelphia is eliminated.
    They can win at most 80 + 3 = 83 games.
    New_York and Atlanta have won a total of 161 games.
    They play each other 6 times.
    On average, each of the teams in this group wins 167 / 2 = 83.5 games.
    Therefore one team will win at least 84 games.
     
    Montreal is eliminated.
    They can win at most 77 + 3 = 80 games.
    Atlanta has already won 83 games.

### Elimination Certificate for Division 2

    >> julia elimination.jl ./divisions/division_2.txt
    Detroit is eliminated.
    They can win at most 49 + 27 = 76 games.
    Boston and New_York and Baltimore and Toronto have won a total of 278 games.
    They play each other 27 times.
    On average, each of the teams in this group wins 305 / 4 = 76.25 games.
    Therefore one team will win at least 77 games.

### Elimination Certificate for Random 5 Team Quidditch League (Method 1)

    >> julia main_quidditch.jl 5
    Montrose_Magpies is eliminated after 8 total matches in the season.
    They can win at most 0 + 4 = 4 games.
    Tutshill_Tornados and Appleby_Arrows and Ballycastle_Bats have won a total of 7 games.
    They play each other 6 times.
    On average, each of the teams in this group wins 13 / 3 = 4.33 games.
    Therefore one team will win at least 5 games.
     
    Wimbourne_Wasps is eliminated after 9 total matches in the season.
    They can win at most 1 + 3 = 4 games.
    Tutshill_Tornados and Ballycastle_Bats and Appleby_Arrows have won a total of 8 games.
    They play each other 6 times.
    On average, each of the teams in this group wins 14 / 3 = 4.67 games.
    Therefore one team will win at least 5 games.

    Appleby_Arrows is eliminated after 15 total matches in the season.
    They can win at most 3 + 2 = 5 games.
    Tutshill_Tornados has already won 6 games.

    Tutshill_Tornados is eliminated after 17 total matches in the season.
    They can win at most 6 + 0 = 6 games.
    Ballycastle_Bats has already won 7 games.

### Elimination Certificate for Random 13 Team Quidditch League (Method 2)

    >> julia gen_quidditch.jl
    >> julia elimination_quidditch.jl 
    Puddlemere_United is eliminated after 82 total matches in the season.
    They can win at most 2 + 9 = 11 games.
    Pride_of_Portree has already won 12 games.
     
    Wimbourne_Wasps is eliminated after 102 total matches in the season.
    They can win at most 8 + 5 = 13 games.
    Pride_of_Portree has already won 14 games.
      
    Kenmare_Kestrels is eliminated after 110 total matches in the season.
    They can win at most 3 + 11 = 14 games.
    Pride_of_Portree has already won 15 games.
       
    Montrose_Magpies is eliminated after 114 total matches in the season.
    They can win at most 10 + 4 = 14 games.
    Pride_of_Portree has already won 15 games.

    Ballycastle_Bats is eliminated after 116 total matches in the season.
    They can win at most 6 + 8 = 14 games.
    Holyhead_Harpies has already won 15 games.

    Tutshill_Tornados is eliminated after 123 total matches in the season.
    They can win at most 10 + 5 = 15 games.
    Holyhead_Harpies has already won 16 games.

    Falmouth_Falcons is eliminated after 123 total matches in the season.
    They can win at most 11 + 3 = 14 games.
    Holyhead_Harpies has already won 16 games.

    Wigtown_Wanderers is eliminated after 126 total matches in the season.
    They can win at most 6 + 9 = 15 games.
    Holyhead_Harpies has already won 16 games.

    Caerphilly_Catapults is eliminated after 130 total matches in the season.
    They can win at most 12 + 4 = 16 games.
    Holyhead_Harpies has already won 17 games.

    Appleby_Arrows is eliminated after 130 total matches in the season.
    They can win at most 11 + 5 = 16 games.
    Holyhead_Harpies has already won 17 games.

    Pride_of_Portree is eliminated after 130 total matches in the season.
    They can win at most 15 + 1 = 16 games.
    Holyhead_Harpies has already won 17 games.

    Chudley_Cannons is eliminated after 135 total matches in the season.
    They can win at most 12 + 4 = 16 games.
    Holyhead_Harpies has already won 17 games.

### Elimination Certificate for Quidditch League 3

    >> julia elimination_quidditch.jl ./divisions/quidditch_div3/
    Pride_of_Portree is eliminated after 90 total matches in the season.
    They can win at most 0 + 12 = 12 games.
    Ballycastle_Bats has already won 13 games.

    Chudley_Cannons is eliminated after 104 total matches in the season.
    They can win at most 3 + 10 = 13 games.
    Tutshill_Tornados has already won 14 games.

    Kenmare_Kestrels is eliminated after 105 total matches in the season.
    They can win at most 7 + 6 = 13 games.
    Tutshill_Tornados has already won 14 games.

    Appleby_Arrows is eliminated after 108 total matches in the season.
    They can win at most 6 + 7 = 13 games.
    Tutshill_Tornados has already won 14 games.

    Falmouth_Falcons is eliminated after 112 total matches in the season.
    They can win at most 9 + 4 = 13 games.
    Tutshill_Tornados has already won 14 games.

    Wimbourne_Wasps is eliminated after 120 total matches in the season.
    They can win at most 10 + 4 = 14 games.
    Tutshill_Tornados has already won 15 games.

    Caerphilly_Catapults is eliminated after 141 total matches in the season.
    They can win at most 13 + 1 = 14 games.
    Tutshill_Tornados has already won 15 games.

    Holyhead_Harpies is eliminated after 143 total matches in the season.
    They can win at most 12 + 2 = 14 games.
    Tutshill_Tornados has already won 15 games.

    Wigtown_Wanderers is eliminated after 147 total matches in the season.
    They can win at most 14 + 1 = 15 games.
    Ballycastle_Bats has already won 16 games.

    Tutshill_Tornados is eliminated after 153 total matches in the season.
    They can win at most 15 + 0 = 15 games.
    Puddlemere_United has already won 16 games.

    Montrose_Magpies is eliminated after 155 total matches in the season.
    They can win at most 15 + 0 = 15 games.
    Puddlemere_United has already won 16 games.

    Ballycastle_Bats is eliminated after 156 total matches in the season.
    They can win at most 16 + 0 = 16 games.
    Puddlemere_United has already won 17 games.
