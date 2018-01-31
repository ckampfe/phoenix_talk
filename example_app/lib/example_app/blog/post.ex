defmodule ExampleApp.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Blog.{Post, Comment}


  schema "posts" do
    field :body, :string
    field :title, :string

    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
