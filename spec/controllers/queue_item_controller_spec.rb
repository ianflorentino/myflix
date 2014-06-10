require 'spec_helper'

describe QueueItemController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue1 = Fabricate(:queue_item, user: user)
      queue2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue1, queue2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(respose).to redirect_to sign_in_path
    end
  end
end