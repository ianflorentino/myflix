require 'spec_helper'

describe VideosController do 
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id 
      expect(assigns(:video)).to eq(video)
    end
    it "redirects the user to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
    it "sets the review variable" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end
  describe "POST search" do
    it "sets @search for authenticated users " do
      session[:user_id] = Fabricate(:user).id
      the_office = Fabricate(:video, title: 'The Office')
      post :search, search_term: 'office'
      expect(assigns(:search)).to eq([the_office])
    end
    it "redirects the user to the sign in page for unauthenticated users" do
      the_office = Fabricate(:video, title: 'The Office')
      post :search, search_term: 'office'
      expect(response).to redirect_to sign_in_path
    end
  end

end
