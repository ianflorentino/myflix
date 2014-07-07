require 'spec_helper'

describe VideosController do 
  describe "GET show" do
    before do 
      set_current_user
      @video = Fabricate(:video)
    end
    
    it "sets @video for authenticated users" do
      get :show, id: @video.id 
      expect(assigns(:video)).to eq(@video)
    end
    
    it "sets the review variable" do
      review1 = Fabricate(:review, video: @video)
      review2 = Fabricate(:review, video: @video)
      get :show, id: @video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    
    it_behaves_like "require_sign_in" do
      let(:action) {get :show, id: @video.id}
    end
  end
  describe "POST search" do
    it "sets @search for authenticated users " do
      set_current_user
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
