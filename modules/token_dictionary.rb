module Token_Dictionary
    TOKEN_MAP = {
        black:{
            king:"♔",
            queen:"♕",
            rook:"♖",
            bishop:"♗",
            knight:"♘",
            pawn:"♙"
        },
        white:{
            king:"♚",
            queen:"♛",
            rook:"♜",
            bishop:"♝",
            knight:"♞",
            pawn:"♟"
        }
    }
    MOVE_MAP = {
        king: [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]],
        queen: [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]],
        rook: [[0,1],[0,-1],[1,0],[-1,0]],
        bishop: [[1,1],[1,-1],[-1,1],[-1,-1]],
        knight: [[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1]],
        pawn:{
            black: {
                initial: [[1,0],[2,0]],
                post: [[1,0]],
                capture: [[1,-1],[1,1]]
            },
            white: {
                initial: [[-1,0],[-2,0]],
                post: [[-1,0]],
                capture: [[-1,-1],[-1,1]]
            }, 
        }
    }
end