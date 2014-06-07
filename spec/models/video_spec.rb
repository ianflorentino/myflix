require 'spec_helper'
require 'shoulda/matchers'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

describe "search_by_title" do
    it "returns an empty array of results that do not match" do
      big_bang_theory = Video.create(title: "The Big Bang Theory", description: "Season 6", category_id: 1)
      new_girl = Video.create(title: "New Girl", description: "Season 3", category_id: 1)
      expect(Video.search_by_title("game")).to eq([])
    end
    it "returns an array of a result of one video for an exact match" do
      the_office = Video.create(title: "The Office", description: "Season 1", category_id: 1)
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 2)
      expect(Video.search_by_title("the office")).to eq([the_office])
    end
    it "returns an array of one video for a partial match" do
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 2)
      the_game = Video.create(title: "The Game", description: "Season 2", category_id: 3)
      expect(Video.search_by_title("throne")).to eq([game_of_thrones])
    end
    it "returns an array of all matches ordered by created_at" do
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 2)
      the_game = Video.create(title: "The Game", description: "Season 2", category_id: 3, created_at: 1.day.ago)
      expect(Video.search_by_title("Game")).to eq([game_of_thrones, the_game])
    end
    it "returns an empty array for an empty string" do
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 2)
      the_game = Video.create(title: "The Game", description: "Season 2", category_id: 3, created_at: 1.day.ago)
      expect(Video.search_by_title("")).to eq([])  
    end
   end
end