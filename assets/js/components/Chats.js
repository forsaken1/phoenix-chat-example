import React from "react"
import { ListGroup, Button, Row, Col } from 'react-bootstrap'
import { Socket } from "phoenix"

const HEADERS = {
  'Content-Type': 'application/json',
  Accept: 'application/json',
}

class Chats extends React.Component {
  constructor(props) {
    super(props)

    this.messagesContainerRef = React.createRef();

    this.state = {
      users: [],
      conversations: {},
      selectedUser: null,
      message: '',
      socket: null,
      channels: []
    }
  }
  
  componentDidMount() {
    this.fetchUsers();

    let socket = new Socket("/socket", {params: {token: this.props.userToken}});
    socket.connect();
    this.setState({socket});
  }

  chatId = (firstId, secondId) => {
    const ids = [firstId, secondId];
    const sortedIds = ids.sort();

    return '' + sortedIds[0] + '-' + sortedIds[1];
  }

  handleChannel = (user) => {
    const { currentUserId } = this.props;
    const { socket } = this.state;
    let channel = socket.channel("chat-" + this.chatId(currentUserId, user.id), {})
    channel.join()
    channel.on('new_message', this.handleReceivedConversation)
  }

  fetchUsers() {
    fetch('/users')
      .then(res => res.json())
      .then(res => {
        const selectedUser = res.users[0];

        if(selectedUser) {
          this.fetchMessages(selectedUser.id);
        }
        res.users.map(user => this.handleChannel(user));
        this.setState({users: res.users, selectedUser});
      })
  }

  fetchMessages(userId) {
    fetch('/messages?user_id=' + userId)
      .then(res => res.json())
      .then(res => {
        const { conversations } = this.state;
        this.setState({conversations: { ...conversations, [userId]: res.messages }}, this.scrollDown);
      })
  }

  scrollDown = _ => {
    this.messagesContainerRef.current.scrollTop = this.messagesContainerRef.current.scrollHeight;
  }

  handleReceivedConversation = (response) => {
    const { currentUserId } = this.props;
    const { conversations } = this.state;
    const userId = response.user_from_id == currentUserId ? response.user_to_id : response.user_from_id;
    const messages = conversations[userId] ? conversations[userId] : [];
    
    this.setState({conversations: {...conversations, [userId]: [...messages, response]}}, this.scrollDown);
  }

  handleSendButton = event => {
    event.preventDefault();

    const { selectedUser, message } = this.state;
    const data = JSON.stringify({user_id: selectedUser.id, text: message});

    if(message != '') {
      fetch('/messages', { method: 'POST', body: data, headers: HEADERS })
        .then(_ => {
          this.setState({message: ''});
          this.scrollDown();
        })
    }
  }

  handleUpdateTextarea = event => {
    const message = event.currentTarget.value;
    this.setState({message});
  }

  handleSelectUser = selectedUser => {
    this.setState({selectedUser});
    this.fetchMessages(selectedUser.id);
  }

  render() {
    const { users, conversations, message, selectedUser } = this.state;
    const { currentUserId } = this.props;
    const messages = selectedUser && conversations[selectedUser.id] ? conversations[selectedUser.id] : [];

    return (
      <Row className="chats-container">
        <Col sm={3}>
          <ListGroup>
            {users.map((user, i) =>
              <ListGroup.Item className={selectedUser.id === user.id ? 'active' : ''} key={i} onClick={_ => this.handleSelectUser(user)}>{user.name}</ListGroup.Item>)}
          </ListGroup>
        </Col>
        <Col sm={6}>
          <div id="messages" className="messages-container" ref={this.messagesContainerRef}>
            {messages.map((message, i) =>
              <div key={i} className={'message' + (message.user_from_id === currentUserId ? ' message__right' : '')}>{message.text}</div>)}
          </div>
          <div className="actions">
            <textarea value={message} onChange={this.handleUpdateTextarea} className="message-field"/>
            <Button variant="primary" onClick={this.handleSendButton} className="btn btn-default send-message-button">Send</Button>
          </div>
        </Col>
      </Row>
    )
  }
}

export default Chats