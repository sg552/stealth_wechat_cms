ShakeShake::Application.routes.draw do
  resources 'interfaces' do
    collection do
      #get :check_signature
    end
  end
  # root 'welcome#index'
end
