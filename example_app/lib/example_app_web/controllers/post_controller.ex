defmodule ExampleAppWeb.PostController do
  use ExampleAppWeb, :controller

  alias ExampleApp.Blog
  alias ExampleApp.Blog.{Post, Comment}

  def index(conn, _params) do
    conn
    |> assign(:posts, Blog.list_posts())
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Blog.change_post(%Post{}))
    |> render("new.html")
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:post, Blog.get_post!(id))
    |> assign(:comment_changeset, Blog.change_comment(%Comment{}))
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)

    conn
    |> assign(:post, post)
    |> assign(:changeset, Blog.change_post(post))
    |> render("edit.html")
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:post, post)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
