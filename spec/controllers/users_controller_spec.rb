require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)    
    end
  end
  describe 'POST create' do
    context "with valid input" do
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "creates the user record" do
        expect(User.count).to eq(1)
      end
      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before do 
        post :create, user: { email: "fake@email.com", full_name: "Faker Fake"}
      end
      it "does not create a user" do
        expect(User.count).to eq(0) 
      end
      it "renders a new template" do
        expect(response).to render_template :new 
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)  
      end
    end
  end
end