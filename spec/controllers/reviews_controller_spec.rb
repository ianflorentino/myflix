require 'spec_helper'

describe ReviewsController do
  describe "POST create review" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }
      context "with valid inputs" do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end
        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(current_user)
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to(video_path(current_user))
        end
      end
      context "with invalid inputs" do
        it "does not create a review" do
          post :create, video_id: video.id, review: { rating: 4 }
          expect(Review.count).to eq(0) 
        end
        it "renders the video show template" do
          post :create, video_id: video.id, review: { rating: 4 }
          expect(response).to render_template('videos/show') 
        end
        it "sets @video" do
          post :create, video_id: video.id, review: { rating: 4 }
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: { rating: 4 }
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        video = Fabricate(:video)
        post :create, video_id: video.id, review: Fabricate(:review)
        expect(response).to redirect_to(sign_in_path)
      end
    end  
  end
  describe "GET destroy review" do
    before do
      @user1 = Fabricate(:user)
      @user2 = Fabricate(:user)
      @video = Fabricate(:video)
      @review1 = Fabricate(:review, video: @video, user: @user1)
      @review2 = Fabricate(:review)
    end
    it "removes a review" do
      session[:user_id] = @user1.id
      delete :destroy, video_id: @video.id, id: @review1
      expect(Review.all).to match_array([@review2])
    end
    it "only allows the user of the review to delete it" do
      session[:user_id] = @user2.id
      delete :destroy, video_id: @video.id, id: @review1
      expect(Review.all).to match_array([@review1, @review2])
    end
  end
end