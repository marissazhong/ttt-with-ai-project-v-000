module Players
  class Computer < Player
    def all_moves(board)
      #assumes first player token is "X" and second player token is "O"
      moves = [[],[]]
      board_positions = board.cells.map.with_index(1).to_a
      board_positions.map {|space|
        if space[0] == "X"
          moves[0] << space[1]
        elsif space[1] == "O"
          moves[1] << space[1]
        end
      }
      moves
    end

    def move(board)
      if board.cells[4] == " " #always choose middle position if open
        "5"
      else
        current_player_valid_combos = []
        other_player_valid_combos = []
        current_player = (all_moves(board)[0].length == all_moves(board)[1].length ? "X" : "O")
        other_player = (all_moves(board)[0].length == all_moves(board)[1].length ? "O" : "X")
        current_check_values = [" ",current_player]
        other_check_values = [" ",other_player]
        Game::WIN_COMBINATIONS.map {|combo|
          other_player_closest = [0,"combo"] # [how many spots occupied towards a solution, closest combo to a solution]
          if current_check_values.include?(board.cells[combo[0]]) && current_check_values.include?(board.cells[combo[1]]) && current_check_values.include?(board.cells[combo[2]])
            current_player_valid_combos << combo
          elsif other_check_values.include?(board.cells[combo[0]]) && other_check_values.include?(board.cells[combo[1]]) && other_check_values.include?(board.cells[combo[2]])
            other_player_valid_combos << combo
            other_player_moves = 0
            combo.each {|position|
              other_player_moves += 1 if board.cells[position] == other_player
              if other_player_moves > other_player_closest[0]
                other_player_closest = [0,0]
                other_player_closest[0] = other_player_moves
                other_player_closest[1] = combo
              end
          }
            puts other_player_closest
            if other_player_closest[0] = 2
              other_player_closest[1].each_index.select{|i| board.cells[other_player_closest[1][i]] == " "}[0] + 1
            elsif other_player_closest[0] = 1
              index = other_player_closest[1].each_index.select{|i| board.cells[other_player_closest[1][i]] == other_player}[0]
              if index.even?
                other_player_closest[1][1] + 1
              else
                [other_player_closest[1][0],other_player_closest[1][2]].sample + 1
              end
            end
          end
        }
        # There are two strategies for moving - 1. block the other player from winning 2. pick the best move for yourself

        # 1. if other player has two in a row, block the third position

        # 2. if other player has one, fill position in one of those solutions

        # 3. otherwise, select the best move for myself
        # all_moves = valid_combos.flatten
        # best_move = Hash[0,0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0]
        # all_moves.each {|move| best_move[move] += 1}
        # best_move.max_by {|key,value| value}[0] + 1
      end
    end
  end
end
