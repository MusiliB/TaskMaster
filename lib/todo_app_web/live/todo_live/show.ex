defmodule TodoAppWeb.TodoLive.Show do
  use TodoAppWeb, :live_view

  alias TodoApp.Todos

  on_mount {TodoAppWeb.UserAuth, :require_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Todo {@todo.id}
        <:subtitle>This is a todo record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/todos"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/todos/#{@todo}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit todo
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@todo.title}</:item>
        <:item title="Done">{@todo.done}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do

     user = socket.assigns.current_scope.user

    {:ok,
     socket
     |> assign(:page_title, "Show Todo")
     |> assign(:todo, Todos.get_todo!(user, id))}
  end
end
