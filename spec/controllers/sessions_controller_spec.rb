require 'spec_helper'

describe SessionsController do
  describe "GET new" do 
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  describe "POST create" do
    context "with valid credentials" do
      before do
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password, full_name: @user.full_name
      end
      it "creates the session" do
        expect(session[:user_id]).to eq(@user.id)
      end
      it "redirects to the home path" do
       expect(response).to redirect_to home_path
      end
    end
    context "with invalid credentials" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password + 'asdf', full_name: user.full_name  
      end   
      it "does not create a session when input is invalid" do
        expect(session[:user_id]).to be_nil
      end
      it "redirects to the sign in path when input is invalid" do
        expect(response).to redirect_to sign_in_path
      end
      end
  end
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "clears the sessions for the user" do
      expect(session[:user_id]).to be_nil
    end
    it "redirects to root_path" do
      expect(response).to redirect_to root_path 
    end
  end
end