defmodule ExampleApp.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExampleApp.Blog.{Comment, Post}


  schema "comments" do
    field :body, :string

    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:body])
    |> put_assoc(:post, attrs["post"])
    |> validate_required([:body])
  end
end
