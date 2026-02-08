# Socket Matchmaking Demo - README

## Overview
A WebSocket-based matchmaking system that pairs users into chat rooms based on their profiles and facilitates real-time messaging.


## Events Reference

### **Client → Server**

#### `join_pool`
**When**: User clicks "Join Pool" button  
**Purpose**: Enter matchmaking queue  
**Payload**:
```javascript
{
  email: string,
  gender: number,        // 0 = Boy, 1 = Girl
  interests: string[],   // Array of interests
  timejoined: number,    // Timestamp
  room: null,
  chatStarted: null
}
```

#### `chat_message`
**When**: User sends a message during active chat  
**Purpose**: Send message to matched partner  
**Payload**:
```javascript
{
  roomId: string,
  message: string
}
```

#### `continue_response`
**When**: User responds to continuation prompt  
**Purpose**: Answer if they want to keep chatting  
**Payload**:
```javascript
{
  roomId: string,
  answer: "yes" | "no"
}
```

#### `leave`
**When**: User clicks "Leave/Disconnect" or chat ends  
**Purpose**: Exit current room and matchmaking  
**Payload**: None

---

### **Server → Client**

#### `matched`
**When**: Server finds a match  
**Handle**: Store `roomId`, show chat interface  
**Payload**:
```javascript
{
  roomId: string
}
```

#### `questions`
**When**: After match, server sends icebreaker questions  
**Handle**: Display questions in chat  
**Payload**: `string[]` (array of questions)

#### `chat_message`
**When**: Partner sends a message  
**Handle**: Display in chat messages  
**Payload**: `string` (message text)

#### `continue_prompt`
**When**: Server asks if users want to continue  
**Handle**: Show confirmation dialog, send `continue_response`  
**Payload**: None

#### `continue_response`
**When**: Both users agreed to continue  
**Handle**: Display partner's email  
**Payload**: `string` (partner email)

#### `chat_closed`
**When**: System closes chat (time limit/user declined)  
**Handle**: Alert user, call `leave()`, reset UI  
**Payload**: None

#### `partner_disconnected`
**When**: Partner's connection drops  
**Handle**: Alert user, call `leave()`, reset UI  
**Payload**: None

#### `partner_left`
**When**: Partner manually leaves  
**Handle**: Alert user, call `leave()`, reset UI  
**Payload**: None

---

## Message Flow

1. **Join** → Send `join_pool`
2. **Wait** → Receive `matched` with roomId
3. **Icebreakers** → Receive `questions`
4. **Chat** → Exchange `chat_message` events
5. **Continue?** → Receive `continue_prompt` → Send `continue_response`
6. **Exchange Emails** → Receive `continue_response` (if both said yes)
7. **End** → Receive termination event OR send `leave`

---

## Error Handling

- **Connection Lost**: `ws.onclose` / `ws.onerror` (not implemented in demo)
- **Partner Issues**: Handle `partner_disconnected`, `partner_left`
- **System Closure**: Handle `chat_closed`

Always call `leave()` to reset state when chat ends unexpectedly.