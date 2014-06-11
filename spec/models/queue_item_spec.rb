require 'spec_helper'
require 'shoulda/matchers'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'Title')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('Title')
    end
  end

  describe "#rating" do
    it "returns the rating of the video if a rating is present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end

    it "returns a nil if no rating is present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category name of the video" do
      category = Fabricate(:category, name: 'Comedy')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#category" do
    it "returns the category id of the video" do
      category = Fabricate(:category, name: 'Comedy')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end