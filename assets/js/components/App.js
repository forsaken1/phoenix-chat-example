import React from 'react'
import ReactDOM from 'react-dom'
import Homepage from './Homepage'

const root = document.getElementById('root')

if(root) {
  const currentUserId = parseInt(root.getAttribute('currentUserId'))
  const userToken = root.getAttribute('userToken')
  
  ReactDOM.render(
    <Homepage currentUserId={currentUserId} userToken={userToken}/>,
    root
  )
}
