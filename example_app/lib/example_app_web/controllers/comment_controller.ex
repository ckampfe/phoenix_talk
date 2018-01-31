defmodule ExampleAppWeb.CommentController do
  use ExampleAppWeb, :controller
  alias ExampleApp.Blog

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    comment_params
    |> Map.merge(%{"post" => Blog.get_post!(post_id)})
    |> Blog.create_comment

    redirect(conn, to: post_path(conn, :show, post_id))
  end
end
