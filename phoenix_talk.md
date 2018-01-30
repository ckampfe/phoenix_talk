# phoenix talk

# present a tension

## things that suck about rails

- the "everything is mvc" code organization doesn't work at scale
- concurrency model leads to high memory use
- garbage collection is bad, leads to pauses and unpredictable latencies
- inheritance-based API that loads hundreds of classes for controllers, models, views is hard to trace
- processing something outside of the request/response cycle requires a background job server
- test suites quickly become slow
- app startup times in dev require hacks like Spring that lead to subtle app state bugs
- activerecord callbacks are hell
- poor notion of pure data, everything important usually has to be an Activerecord Model
- state is implicit in everything
- hard to create composable operations that might fail


# alleviate a tension

## things that rock about phoenix

- the web portion of your app is just that: a portion
- the database portion of your app is just that: a portion
- elixir gc is process-level, so processes don't block each other and tail latencies are fast
- composition/macro based API allows you to see the exact code your MVC is loading with `use`
- processing stateless things outside of request/response is `Task.Supervisor.start_child/3`
- can run test suites in parallel trivially
- app startup times are fast, code is AOT compiled
- pure data is the default, database models are an important augmentation
- state is explicit: either a genserver or a database
- `with` expressions easily compose operations that might fail


-------------

# dpick notes

## good stuff

- different configs per env by default
- dev mode is fast
- pattern matching makes things awesome in test and for composing queries
- designed for 5 nines

```
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

- pattern matching provides "structural types"
- def `update_person(%Person{} = person) do...`
- `def index(conn, %{"title" => title}) do` will blow up if it gets passed a params hash that doesn't have `title`
- Not having to do `foo[:bar] && foo[:bar][:baz]`
- built in pry and debugger
- preload instead of n+1's
- doctests
- router pipelines
- streams
- changesets


## bad stuff
 
- sometimes bad error messages
- ecto feels immature at times
- docs outside of core/phoenix are mixed
- macros can be confusing

-------------

# Themes

- what is the problem
- rails tension
- your skills transfer
- explicitness (changesets, state)
- things that contribute to longevity (env-based, config, testing)
- power (channels, pattern matching)


- creature comforts
- maintainability
- power
