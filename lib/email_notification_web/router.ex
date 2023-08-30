defmodule EmailNotificationWeb.Router do
  use EmailNotificationWeb, :router

  import EmailNotificationWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EmailNotificationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_admin do
    plug EmailNotificationWeb.RequireAdminRole
  end

  scope "/", EmailNotificationWeb do
    pipe_through :browser

    # live "/", HomeLive.Index, :index
    # User Routes
    # live "/users", UserLive.Index, :index
    # live "/users/new", UserLive.Index, :new
    # live "/users/:id/edit", UserLive.Index, :edit
    # live "/users/:id", UserLive.Show, :show
    # live "/users/:id/show/edit", UserLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmailNotificationWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:email_notification, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EmailNotificationWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EmailNotificationWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{EmailNotificationWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", EmailNotificationWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{EmailNotificationWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/", ContactLive.Index, :index
      # Contacts Routes
      live "/contacts", ContactLive.Index, :index
      live "/contacts/new", ContactLive.Index, :new
      live "/contacts/:id/edit", ContactLive.Index, :edit
      live "/contacts/:id", ContactLive.Show, :show
      live "/contacts/:id/show/edit", ContactLive.Show, :edit
      # Emailing Routes
      live "/emails", EmailLive.Index, :index
      live "/emails/new", EmailLive.Index, :new
      live "/emails/:id/edit", EmailLive.Index, :edit
      live "/emails/:id", EmailLive.Show, :show
      live "/emails/:id/show/edit", EmailLive.Show, :edit

      # Groups Routes
      live "/groups", GroupLive.Index, :index
      live "/groups/new", GroupLive.Index, :new
      live "/groups/:id/edit", GroupLive.Index, :edit
      live "/groups/:id", GroupLive.Show, :show
      live "/groups/:id/show/edit", GroupLive.Show, :edit

      # CUSTOM GROUP CONTACTS ROUTES
      live "/groups/:id/groupcontacts/new", GroupContactLive.Index, :new

      # # Admin Routes
      # live "/admins", AdminLive.Index, :index
      # live "/admins/new", AdminLive.Index, :new
      # live "/admins/:id/edit", AdminLive.Index, :edit
      # live "/admins/:id", AdminLive.Show, :show
      # live "/admins/:id/show/edit", AdminLive.Show, :edit 

      # GROUP CONTACTS ROUTES
      live "/groupcontacts", GroupContactLive.Index, :index
      # live "/groupcontacts/new", GroupContactLive.Index, :new
      live "/groupcontacts/:id/edit", GroupContactLive.Index, :edit

      live "/groupcontacts/:id", GroupContactLive.Show, :show
      live "/groupcontacts/:id/show/edit", GroupContactLive.Show, :edit
    end
  end




  scope "/", EmailNotificationWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    live_session :require_authenticated_user_admin,
      on_mount: [{EmailNotificationWeb.UserAuth, :ensure_authenticated}] do
      live "/admins", AdminLive.Index, :index
      live "/admins/new", AdminLive.Index, :new
      live "/admins/:id/edit", AdminLive.Index, :edit
      live "/admins/:id", AdminLive.Show, :show
      live "/admins/:id/show/edit", AdminLive.Show, :edit
    end
  end




  scope "/", EmailNotificationWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{EmailNotificationWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
