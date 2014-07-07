require 'spec_helper'
require 'pry'

describe QueueItemsController do
  describe "GET index" do
    before { set_current_user }
    it "sets @queue_items to the queue items of the logged in user" do
      queue1 = Fabricate(:queue_item, user: current_user)
      queue2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue1, queue2])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "with authenticated user" do
     
      before do
        set_current_user
        @video = Fabricate(:video)
      end
     
      it "redirects to the my_queue page" do
        post :create, video_id: @video.id, user: current_user
        expect(response).to redirect_to(my_queue_path)
      end
     
      it "creates a queue item" do
        post :create, video_id: @video.id, user: current_user
        expect(QueueItem.count).to eq(1)
      end
     
      it "creates the queue item that is associated with the video" do
        post :create, video_id: @video.id, user: current_user
        expect(QueueItem.first.video).to eq(@video)
      end
     
      it "creates the queue item that is associated with the current_user" do
        post :create, video_id: @video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
     
      it "positions the video in the last spot of the queue" do
        Fabricate(:queue_item, video: @video, user: current_user, position: 1)
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2, user_id: current_user).first
        expect(video2_queue_item.position).to eq(2)
      end
     
      it "does not add the video to the queue if the video is already in the queue" do
        QueueItem.create(video: @video, user: current_user, position: 1)
        post :create, video_id: @video.id, user: current_user
        expect(QueueItem.count).to eq(1)  
      end
      
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, video_id: @video.id }
      end
    end

 
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      
      before do
        set_current_user
        video2 = Fabricate(:video)
        Fabricate(:queue_item, video: video2, user: current_user, position: 2)
        @video2_queue_item = QueueItem.where(video_id: video2.id, user_id: current_user).first
      end
      
      it "removes the selected queue item from the Queue" do  
        delete :destroy, id: @video2_queue_item.id  
        expect(QueueItem.count).to eq(0)
      end
      
      it "redirects to User's queue page" do
        delete :destroy, id: @video2_queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end
      
      it "doesnt not delete the queue item that is not in current user's queue" do
        user1 = Fabricate(:user)
        video3 = Fabricate(:video)
        Fabricate(:queue_item, video: video3, user: user1, position: 1)
        delete :destroy, id: @video2_queue_item.id
        expect(user1.queue_items.count).to eq(1)
      end
      
      it "normalizes the remaining queue items" do
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 1)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.first.position).to eq(1)
      end

      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: 3 }
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do

      before { set_current_user }

      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2, video: video) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end  
      
      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq([1, 2])
      end
      
      # it "updates the rating" do
      #   user = Fabricate(:user)
      #   session[:user_id] = user.id
      #   queue_item1 = Fabricate(:queue_item, user: user, position: 1, video_id: 1)
      #   queue_item2 = Fabricate(:queue_item, user: user, position: 2, video_id: 2)
      #   post :update_queue, queue_items: [{id: queue_item1.id, position: 3, rating: 4}, {id: queue_item2.id, position: 2, rating: 3}]  
      #   binding.pry
      #   expect(user.queue_items.map(&:rating)).to eq([4, 3])
      # end
    end
    context "with invalid inputs" do
      
      before do
        set_current_user
      end
      
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2, video: video) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2.1}]
        expect(response).to redirect_to(my_queue_path)
      end
      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2.1}]
        expect(flash[:danger]).to be_present
      end
      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :update_queue, queue_items: [{id: 2, position: 1}, {id: 3, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        set_current_user
        user2 = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user2, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end