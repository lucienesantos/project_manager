Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :projects do
        member do
          put :conclude

          resources :notes do
            member do
              patch :archive
            end
          end
        end
      end
      match 'archive', to: 'projects#archive', via: [:patch]
    end
  end

end
