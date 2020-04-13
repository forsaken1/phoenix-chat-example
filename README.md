# Phoenix Chats Example

## Reference

You can see, how it works on Rails here: https://github.com/forsaken1/anycable-chat-example

## Run

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Infrastructure

It's just a simple Phoenix application with default Phoenix Channels and Coherence (only authentification, Devise-like library)

## Details

1. Phoenix Channels configuration

```elixir
defmodule ExampleWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "chat-*", ExampleWeb.ChatChannel
  
  ...

  def connect(%{"token" => token}, socket) do
    case Coherence.verify_user_token(socket, token, &assign/3) do
      {:error, _} -> :error
      {:ok, socket} -> {:ok, socket}
    end
  end
  
  ...
end
```

```elixir
defmodule ExampleWeb.ChatChannel do
  use Phoenix.Channel

  def join("chat-" <> _chat_id, _message, socket) do
    {:ok, socket}
  end
end
```

2. Broadcasting. IMPORTANT: Phoenix Channel provide also sending messages through websockets from client, but I wanted make like on Rails with Anycable. 

```elixir
  def create(conn, params) do
    changeset = Message.changeset(%Message{}, message_params(conn, params))

    case Repo.insert(changeset) do
      {:ok, message} ->
        ExampleWeb.Endpoint.broadcast Chat.id(current_user(conn).id, params["user_id"]), "new_message", MessagesView.message_json(message)
        render conn, "show.json", message
      {:error, changeset} ->
        json conn, changeset
    end
  end
```

3. Client implementation

```es6
  componentDidMount() {
    this.fetchUsers();

    let socket = new Socket("/socket", {params: {token: this.props.userToken}});
    socket.connect();
    this.setState({socket});
  }
  
  ...

  chatId = (firstId, secondId) => {
    const ids = [firstId, secondId];
    const sortedIds = ids.sort();

    return 'chat-' + sortedIds[0] + '-' + sortedIds[1];
  }
  
  ...
  
  handleChannel = (user) => {
    const { currentUserId } = this.props;
    const { socket } = this.state;
    let channel = socket.channel(this.chatId(currentUserId, user.id), {})
    channel.join()
    channel.on('new_message', this.handleReceivedConversation)
  }

  ...
  
  handleReceivedConversation = (response) => {
    const { currentUserId } = this.props;
    const { conversations } = this.state;
    const userId = response.user_from_id == currentUserId ? response.user_to_id : response.user_from_id;
    const messages = conversations[userId] ? conversations[userId] : [];
    
    this.setState({conversations: {...conversations, [userId]: [...messages, response]}}, this.scrollDown);
  }
```

## Links

  * Official website: https://www.phoenixframework.org/
  * Docs: https://hexdocs.pm/phoenix
  * Useful article: https://medium.com/coding-artist/full-stack-react-with-phoenix-chapter-9-channels-245a24647e84
  * Another useful article: https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
