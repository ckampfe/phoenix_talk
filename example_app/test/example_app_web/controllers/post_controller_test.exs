defmodule ExampleAppWeb.PostControllerTest do
  use ExampleAppWeb.ConnCase

  alias ExampleApp.Blog

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  @username Application.get_env(:example_app, :auth)[:username]
  @password Application.get_env(:example_app, :auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> get(post_path(conn, :new))

      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> post(post_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == post_path(conn, :show, id)

      conn = get(conn, post_path(conn, :show, id))

      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> post(post_path(conn, :create), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> get(post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> put(post_path(conn, :update, post), post: @update_attrs)

      assert redirected_to(conn) == post_path(conn, :show, post)

      conn = get(conn, post_path(conn, :show, post))

      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> put(post_path(conn, :update, post), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = conn
             |> using_basic_auth(@username, @password)
             |> delete(post_path(conn, :delete, post))

      assert redirected_to(conn) == post_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, post_path(conn, :show, post)
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
