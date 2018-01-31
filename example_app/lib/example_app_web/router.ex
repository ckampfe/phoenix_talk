defmodule ExampleAppWeb.Router do
  use ExampleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug BasicAuth, use_config: {:example_app, :auth}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExampleAppWeb do
    pipe_through [:browser, :authenticated]

    resources "/posts", PostController, only: [:edit, :update, :create, :new, :delete] do
      resources "/comments", CommentController, only: [:create]
    end
  end

  scope "/", ExampleAppWeb do
    pipe_through :browser

    get "/", PostController, :index
    resources "/posts", PostController, only: [:index, :show]
  end
end
