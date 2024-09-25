# frozen_string_literal: true

require_relative "../tic-tac-toe"

describe Grid do
  subject(:grid) { described_class.new }

  describe "#add_symbol" do
    context "when the values are valid" do
      it "returns true" do
        expect(grid.add_symbol(0, 0, "x", false)).to eq(true)
      end
    end

    context "when the values are invalid" do
      it "returns true" do
        expect(grid.add_symbol(4, 5, "x", false)).to eq(false)
      end
    end
  end

  describe "#line_tris?" do
    context "when there is no horizontal or vertical tris" do
      it "returns false" do
        expect(grid.line_tris?).to eq(false)
      end
    end

    context "when there is a horizontal tris" do
      it "returns true" do
        symbols_grid = grid.instance_variable_get(:@symbols)
        symbols_grid[0] = ["x", "x", "x"]
        expect(grid.line_tris?).to eq(true)
      end
    end

    context "when there is a vertical tris" do
      it "returns true" do
        symbols_grid = grid.instance_variable_get(:@symbols)
        symbols_grid[0] = ["x", " ", " "]
        symbols_grid[1] = ["x", " ", " "]
        symbols_grid[2] = ["x", " ", " "]
        expect(grid.line_tris?).to eq(true)
      end
    end
  end

  describe "#diagonal_tris?" do
    context "whem there is no diagonal tris" do
      it "returns false" do
        symbols_grid = grid.instance_variable_get(:@symbols)
        symbols_grid[0] = ["x", " ", " "]
        symbols_grid[1] = ["x", " ", " "]
        symbols_grid[2] = ["x", " ", " "]
        expect(grid.diagonal_tris?).to eq(false)
      end
    end

    context "whem there is a diagonal tris" do
      it "returns false" do
        symbols_grid = grid.instance_variable_get(:@symbols)
        symbols_grid[0] = ["x", " ", " "]
        symbols_grid[1] = [" ", "x", " "]
        symbols_grid[2] = [" ", " ", "x"]
        expect(grid.diagonal_tris?).to eq(true)
      end
    end
  end
end


describe Player do
  let(:grid) { instance_double(Grid) }
  subject(:player) { described_class.new("x", grid, false) }

  describe "#human_turn" do
    context "when the space in the grid is alredy occupied" do
      before do
        allow(player).to receive(:print)
        allow(player).to receive(:gets).and_return("0,0", "1,0")
        allow(grid).to receive(:add_symbol).and_return(false, true)
      end

      it "prints an error" do
        expect(player).to receive(:puts).with("Error: Invalid coordinates").once
        player.human_turn
      end
    end
  end
end


describe Game do
  subject(:game) { described_class.new }
  let(:grid) { instance_double(Grid) }
  let(:player) { instance_double(Player) }

  describe "#input_players" do
    context "when input is wrong once" do
      before do
        allow(Grid).to receive(:new).and_return(grid)
        allow(game).to receive(:gets).and_return("#", "0")
        allow(game).to receive(:print)
      end

      it "prints error once" do
        expect(game).to receive(:puts).with("Error: Invalid number").once
        game.input_players
      end
    end
  end

  describe "#play" do
    before do
      allow(game).to receive(:input_players).and_return([player, player])
      allow(game).to receive(:grid).and_return(grid)
      allow(grid).to receive(:print_grid)
      allow(player).to receive(:turn)
      allow(player).to receive(:symbol).and_return("x")
    end

    context "when one player wins" do
      before do
        allow(game).to receive(:puts)
        allow(grid).to receive(:win?).and_return(true)
      end

      it "returns the player" do
        expect(game.play).to eq(player)
      end
    end

    context "when the grid is full" do
      before do
        allow(game).to receive(:puts)
        allow(grid).to receive(:win?).and_return(false)
        allow(grid).to receive(:full?).and_return(true)
      end

      it "returns nil" do
        expect(game.play).to eq(nil)
      end
    end
  end
end
