Omicron::Application.routes.draw do
  resources :committees
  devise_for :users, controllers: {registrations: "registrations"}
  resources :debts
  resources :brothers
  resources :expenses
  resources :deposits
  resources :meetings
  resources :collections

  resources :semesters

  get 'set_current_semester/:semester' => 'semesters#set_current_semester', as: :set_current_semester

  put 'debt/:id/toggle_paid' => 'debts#toggle_paid',  as: :toggle
  get 'debt/:id/new_payment' => 'debts#new_payment',  as: :new_payment
  get 'manage' => 'chapters#index',  as: :manage
  post 'debt/:id/create_payment' => 'debts#create_payment',  as: :create_payment

  put 'expense/:id/toggle_reimbursed' => 'expenses#toggle_reimbursed',  as: :toggle_reimbursed
  put 'expense/:id/toggle_posted' => 'expenses#toggle_posted',  as: :toggle_posted
  get 'expense/not_reimbursed' => 'expenses#not_reimbursed', as: :not_reimbursed
  get 'expense/not_posted' => 'expenses#not_posted', as: :not_posted

  put 'deposit/:id/toggle_deposit_posted' => 'deposits#toggle_deposit_posted', as: :toggle_deposit_posted

  put 'attendance/:id/toggle_attendance' => 'meetings#toggle_attendance',  as: :toggle_attendance

  get 'brother/:id/future_email_nag' => 'brothers#future_email_nag', as: :future_email_nag
  get 'brother/:id/overdue_email_nag' => 'brothers#overdue_email_nag', as: :overdue_email_nag
  get 'brother/:id/text_nag' => 'brothers#text_nag', as: :text_nag
  get 'brother/:id/make_manager' => 'brothers#make_manager', as: :make_manager
  get 'brother/:id/toggle_active' => 'brothers#toggle_active', as: :toggle_active
  get 'brother/future_email_nag_all' => 'brothers#future_email_nag_all', as: :future_email_nag_all
  get 'brother/overdue_email_nag_all' => 'brothers#overdue_email_nag_all', as: :overdue_email_nag_all
  get 'brother/text_nag_all' => 'brothers#text_nag_all', as: :text_nag_all
  get 'brother/bulk_create' => 'brothers#bulk_create', as: :bulk_create
  get 'brother/:status' => 'brothers#index'
  post 'brother/bulk_create' => 'brothers#bulk_create'

  get 'personal' => 'brothers#personal', as: :personal

  get 'brother/:id/add_demerit' => 'brothers#add_demerit', as: :add_demerit
  get 'brother/:id/remove_demerit' => 'brothers#remove_demerit', as: :remove_demerit
  get 'brother/:id/pay_off_demerit' => 'brothers#pay_off_demerit', as: :pay_off_demerit

  post 'brother/search' => 'brothers#search'

  root :to => 'expenses#index'
end
