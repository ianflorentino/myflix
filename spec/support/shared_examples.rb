shared_examples "require_sign_in" do

  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to(sign_in_path)   
  end
end