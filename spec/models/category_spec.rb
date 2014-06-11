require 'spec_helper'
require 'shoulda/matchers'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns the videos in reverse order by created_at" do
      tv_shows = Category.create(name: "Tv Shows")
      big_bang_theory = Video.create(title: "The Big Bang Theory", description: "Season 6", category_id: 1, created_at: 1.day.ago)
      new_girl = Video.create(title: "New Girl", description: "Season 3", category_id: 1, created_at: 2.day.ago)
      the_office = Video.create(title: "The Office", description: "Season 1", category_id: 1, created_at: 3.day.ago)
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 1, created_at: 4.day.ago)
      the_game = Video.create(title: "The Game", description: "Season 2", category_id: 1, created_at: 5.day.ago)
      how_i_met_your_mother = Video.create(title: "How I Met Your Mother", description: "Season 3", category_id: 1, created_at: 6.day.ago)
      expect(tv_shows.recent_videos).to eq([big_bang_theory, new_girl, the_office, game_of_thrones, the_game, how_i_met_your_mother])      
    end  
    it "returns an array of 6 videos if there are more than 6 videos" do
      tv_shows = Category.create(name: "Tv Shows")
      7.times {Video.create(title: "foo", description: "bar", category_id: 1)}
      expect(tv_shows.recent_videos.count).to eq(6)      
    end
    it "returns an array of all videos if there are 6 or less" do
      tv_shows = Category.create(name: "Tv Shows")
      the_office = Video.create(title: "The Office", description: "Season 1", category_id: 1, created_at: 3.day.ago)
      game_of_thrones = Video.create(title: "Game of Thrones", description: "Season 1", category_id: 1, created_at: 4.day.ago)
      the_game = Video.create(title: "The Game", description: "Season 2", category_id: 1, created_at: 5.day.ago)
      how_i_met_your_mother = Video.create(title: "How I Met Your Mother", description: "Season 3", category_id: 1, created_at: 6.day.ago)
      breaking_bad = Video.create(title: "Breaking Bad", description: "Season 5", category_id: 1, created_at: 7.day.ago)
      expect(tv_shows.recent_videos).to eq([the_office, game_of_thrones, the_game, how_i_met_your_mother, breaking_bad])
    end
    it "returns an array of the 6 most recent videos" do
      tv_shows = Category.create(name: "Tv Shows")
      big_bang_theory = Video.create(title: "The Big Bang Theory", description: "Season 6", category_id: 1, created_at: 1.day.ago)
      6.times {Video.create(title: "foo", description: "bar", category_id: 1)}
      expect(tv_shows.recent_videos).not_to include(big_bang_theory)  
    end
    it "returns an empty array, if there are no videos in the category" do
      tv_shows = Category.create(name: "Tv Shows")
      expect(tv_shows.recent_videos).to eq([])
    end
  end
end