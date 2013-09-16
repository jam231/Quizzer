QuizManagement::Application.routes.draw do

  root :to => "grupa_quizowa#index", :id_grupy => 1

  post "odpowiedz_wzorcowa/update" => 'OdpowiedzWzorcowa#update', :as => 'odpowiedz_wzorcowa'
  post "odpowiedz_wzorcowa/create" => 'OdpowiedzWzorcowa#create'

  resources :odpowiedz_wzorcowa

  #get "odpowiedz_wzorcowa/update" => 'OdpowiedzWzorcowa#update'
  #get "odpowiedz_wzorcowa/create" => 'OdpowiedzWzorcowa#create'

  #post 'quiz' => 'Quiz#submit'

  #get 'quiz/:id_quizu' => 'Quiz#index'
  #get 'quiz/question/:id_quizu' => 'Pytanie#edit'
  #get 'pytanie/:id_quizu' => 'Pytanie#edit'

  #get 'pytanie/edit' => 'Pytanie#edit'
  #get 'pytanie/create' => 'Pytanie#create'

  ############################# PYTANIE ############################################

  get "grupa/:id_grupy/quiz/:id_quizu/pytanie/create" => "pytanie#create", :as => 'pytanie_create'
  get "grupa/:id_grupy/quiz/:id_quizu/pytanie/:id_pyt" => "pytanie#edit", :as => 'pytanie'


  post "grupa/:id_grupy/quiz/:id_quizu/pytanie/create" => "pytanie#create", :as => 'pytanie_create'
  post "grupa/:id_grupy/quiz/:id_quizu/pytanie/:id_pyt/edit" => "pytanie#edit", :as => 'pytanie_edit'
  #post "grupa/:id_grupy/quiz/:id_quizu/pytanie/update" => "pytanie#update", :as => 'pytanie_update'

  get "grupa/:id_grupy/quiz/:id_quizu/pytanie/:id_pyt/edit" => "pytanie#edit", :as => 'pytanie_edit'

  delete "grupa/:id_grupy/quiz/:id_quizu/pytanie/:id_pyt/destroy" => "pytanie#destroy", :as => 'pytanie_destroy'


  ############################# QUIZ ###############################################

  # GET i POST
  get "grupa/:id_grupy/quiz/new" => "quiz#new", :as => 'quiz_new'
  get "grupa/:id_grupy/quiz/:id_quizu" => "quiz#index", :as => 'quiz'

  post "grupa/:id_grupy/quiz/create" => "quiz#create", :as => 'quiz_create'
  post "grupa/:id_grupy/quiz/:id_quizu/submit" => "quiz#submit", :as => 'quiz_submit', :id_grupy => /[1-9][0-9]*/

  get "grupa/:id_grupy/quiz/:id_quizu/edit" => "quiz#edit", :as => 'quiz_edit'
  delete "grupa/:id_grupy/quiz/:id_quizu/destroy" => "quiz#destroy", :as => 'quiz_destroy', :id_grupy => /[1-9][0-9]*/
  get "grupa/:id_grupy/quiz/:id_quizu/info" => "quiz#info", :as => 'quiz_info',  :id_grupy => /[1-9][0-9]*/


  ############################# GRUPY QUIZOWE ######################################

  get "public" => "grupa_quizowa#index", :id_grupy => 1, :as => 'grupa_public'

  get "grupa/:id_grupy" => "grupa_quizowa#index", :as => 'grupa', :id_grupy => /[1-9][0-9]*/
  get "grupa/:id_grupy/index" => "grupa_quizowa#index", :as => 'grupa', :id_grupy => /[1-9][0-9]*/
  get "grupa/:id_grupy/quizy" => "grupa_quizowa#quizzes", :as => 'quizy', :id_grupy => /[1-9][0-9]*/
  get "grupa/:id_grupy/ranking" => "grupa_quizowa#ranking", :as => 'ranking', :id_grupy => /[1-9][0-9]*/
  get "grupa/:id_grupy/uzytkownicy" => "grupa_quizowa#users", :as => 'uzytkownicy', :id_grupy => /[1-9][0-9]*/

  get "grupa/new" => "grupa_quizowa#new", :as => 'grupa_new'
  post "grupa/create" => "grupa_quizowa#create", :as => 'grupa_create'



  ############################# Grupa LIMBO ###############


  get "limbo" => "limbo#index", :as => 'grupa_limbo'
  get "limbo/quizzes" => "limbo#quizzes", :as => 'quizzes'
  get "limbo/info/:id_quizu" => "limbo#info", :as => 'limbo_quiz_info'
  get "limbo/moderators" => "limbo#moderators", :as => 'moderators'
  get "limbo/transfer_quiz_to_group/:id_quizu" => "limbo#quiz_group_transfer_form", :as => 'limbo_transfer_quiz_to_group'
  get "limbo/transfer_ownership/:id_quizu" => "limbo#quiz_ownership", :as => 'limbo_transfer_quiz_ownership'

  post "limbo/transfer_quiz_to_group/:id_quizu" => "limbo#transfer_quiz_to_group", :as => 'limbo_transfer_quiz_to_group'
  post "limbo/transfer_ownership/:id_quizu" => "limbo#transfer_quiz_ownership", :as => 'limbo_transfer_quiz_ownership'
  delete "limbo/delete_user_answers/:id_quizu" => "limbo#delete_user_answers", :as => 'limbo_delete_user_answers'


  ############################# Rejestracja, logowanie, profil, etc. ###############

  get "uzytkownik/profil" => "uzytkownik#edit", :as => 'user_edit'

  delete "log_out" => "sessions#destroy", :as => 'log_out'

  get "log_in" => "sessions#new", :as => 'log_in'
  post "log_in" => "sessions#create", :as => 'log_in'

  get "register" => "uzytkownik#new", :as => 'register'
  post "register" => "uzytkownik#create", :as => 'register'

	post "uzytkownik/profil/:id_uz" => "uzytkownik#update", :as => 'user_update'

  #resources :quiz
  #resources :uzytkownik
  #resource :sessions
  #resources :pytanie
  #resources :odpowiedz_wzorcowa

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
