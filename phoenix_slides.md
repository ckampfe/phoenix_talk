# phoenix experience report

---

# we will cover...

- some context
- what Phoenix is/what Elixir is
- what we like about phoenix
- what we don't like about phoenix

---

# not going to cover

- OTP/Advanced Elixir
- Performance
- Package ecosystem
- Observer/runtime debugging

---

# what is phoenix

an elixir web framework

---

# what is phoenix - context

- "A productive web framework that does not compromise speed and maintainability."
- broadly similar to rails
- with some significant structural improvements


---

# problem set

---

# problem set - webapps

```
- accept user input
- present information to the user
- store information in a database
- communicate with external services
- have acceptable end-user latency
- run jobs on a schedule
- with business logic
- over time
```


---

demo phoenix blog app and elixir

---


# our phoenix apps
  
| app           | # files | # loc | timeframe    |
|-----          |---------|-----  |--------------|
| mario         | 85      | 5015  | summer->now  |
| descriptions  | 84      | 9910  | summer->now  |
| yambot        | so many | lots  | eternal      |

---


# what we like

---

# what we like

- familiarity
- explicitness
- power

---

# familiarity

---

# familiarity

- if you know rails, you will feel at home
- cli/generators
- testing is first class
- `pry` is built in

---

## if you know rails

```elixir
mix test               # run those tests
mix phx.server         # start the app
mix phx.routes         # show web routes
mix phx.gen.html       # generate controller, views, etc., for a page
iex -S mix phx.server  # start the server, but with a console
mix ecto.create        # create the db
mix ecto.migrate       # run migrations
mix ecto.gen.migration # generate a migration
```

- boots on localhost:4000
- automatically recompiles on refresh

---

## if you know rails: but wait there's more

```elixir
mix xref graph --format dot # view the relationship of your app's modules as a graph
mix test.watch              # run the tests when something changes
mix format                  # auto-format project code
```

- tests run in parallel with a one-line change
- apps boot in 1 second


---


# explicitness

---

# explicitness

- behavior is mixed in through composition
- phoenix is not your app
- different configs per environment out of the box
- doctests

---

### behavior is mixed in through composition

```elixir
# in our controller
defmodule MarioWeb.PageController do
  use MarioWeb, :controller
  # ...
end
```

```elixir
# in `mario_web.ex`
defmodule MarioWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: MarioWeb
      import Plug.Conn
      import MarioWeb.Router.Helpers
      import MarioWeb.Gettext
    end
  end
  # ...
end

```

---

## phoenix is not your app

```
lib
├── mario
│   ├── aws
│   ├── exceptions
│   ├── materialized_view
│   ├── redshift
│   ├── repos
│   │   ├── adwords
│   │   └── product_keywords
│   ├── sources
│   ├── supervisors
│   └── translators
├── mario_web
│   ├── channels
│   ├── controllers
│   ├── templates
│   │   ├── layout
│   │   └── page
│   └── views
└── tasks

```


---

# doctests

```elixir
@doc """
Insert a value into a circular buffer.
Values are inserted such that when the buffer is full,
the oldest items are overwritten first.

    iex> buf = Cbuf.new(5)
    iex> buf |> Cbuf.insert("a") |> Cbuf.insert("b")
    #Cbuf<["a", "b"]>

    iex> buf = Cbuf.new(3)
    iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.insert(acc, val) end)
    #Cbuf<[18, 19, 20]>
"""
def insert(buf, val) do
  # function body would be here
end
```

---


# power

---

# power

- pattern matching
- "let it crash"
- router pipelines
- parallel tests
- tasks
- channels

---

# pattern matching

```elixir
# in a controller
def index(conn, %{"title" => title}), do: ...
```

```elixir
# in a test
assert %{                                       
  sku: "100A165",                               
  run_date: run_date,                           
  run_id: run_id,                               
  bid_score: 1.2189887039361118,                
  target_cpc: 1.2189887039361118                
} = result                                      
                                                
assert run_date == Date.utc_today |> Date.to_erl
assert run_id   != nil     
```

```elixir
# in a repo or anywhere, really
def update_person(%Person{} = person),  do: ...
```

---

# let it crash

- don't worry about outlier cases, crash instead
- enforce invariants

```elixir
def index(conn, %{"title" => title} = params), do: ...
```

---

# router pipelines

```elixir
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
```

---

# parallel tests

```elixir
defmodule MyTest do
  use ExUnit.Case, async: true
  
  # tests go here...
end
```

```
xcxk066$> mix test
..................................................
..................................................
..................................................
..................................................
..................................................
..................................................
.................

Finished in 0.9 seconds
317 tests, 0 failures
```

---

# tasks

```elixir
Task.Supervisor.start_child(
  Descriptions.TaskSupervisor,
  ShortDescriptions.Core,
  :generate_and_upload_short_description,
  [file.filename,
   defensive_copy_file_path,
   @short_descriptions_bucket,
   @aws_client]
)
```


---

# channels

demo channels with mario app

---

# what we don't like

- cryptic error messages
- ecto immaturity
- docs outside of core libraries
- confusing macros
- smaller ecosystem

---

# takeaways

- we really like Phoenix
- feels like Rails++
- you don't have to be an Elixir expert

---











