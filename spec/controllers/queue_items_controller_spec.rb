require 'spec_helper'

describe QueueItemsController do
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
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    context "with authenticated user" do
      it "redirects to the my_queue page" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, video: video, user: current_user
        expect(response).to redirect_to(my_queue_path)
      end
      it "creates a queue item" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, video_id: video.id, user: current_user
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item that is associated with the video" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, video_id: video.id, user: current_user
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates the queue item that is associated with the current_user" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
      it "positions the video in the last spot of the queue" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        the_office = Fabricate(:video)
        Fabricate(:queue_item, video: the_office, user: current_user, position: 1)
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2, user_id: current_user).first
        expect(video2_queue_item.position).to eq(2)
      end
      it "does not add the video to the queue if the video is already in the queue" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        the_office = Fabricate(:video, title: "The Office")
        QueueItem.create(video: the_office, user: current_user, position: 1)
        post :create, video_id: the_office.id, user: current_user
        expect(QueueItem.count).to eq(1)  
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end