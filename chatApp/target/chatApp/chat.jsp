<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Simple Chat</title>

    <link rel="stylesheet" href="css/style.css">

</head>


<body>

<div class="chat-container">


    <!-- ================= SIDEBAR ================= -->

    <aside class="sidebar">

        <div class="sidebar-header">

            <div class="logo">
                💬
            </div>

            <div>
                <h2>Simple Chat</h2>
                <p>Online Chat</p>
            </div>

        </div>


        <div class="contacts-heading">
            Contacts
        </div>


        <div id="usersList" class="users-list">

            <div class="loading">
                Loading users...
            </div>

        </div>


        <div class="sidebar-bottom">

            <div class="logged-user">

                <div class="user-avatar">
                    <%= username.substring(0, 1).toUpperCase() %>
                </div>

                <div class="logged-user-info">

                    <strong>
                        <%= username %>
                    </strong>

                    <span>
                        Online
                    </span>

                </div>

            </div>


            <button
                type="button"
                class="logout-button"
                onclick="logout()">

                Logout

            </button>

        </div>

    </aside>



    <!-- ================= CHAT AREA ================= -->

    <main class="chat-area">


        <!-- CHAT HEADER -->

        <div class="chat-header">

            <div
                id="headerAvatar"
                class="header-avatar">

                💬

            </div>


            <div>

                <h2 id="chatUser">
                    Select a person
                </h2>

                <p id="chatStatus">
                    Choose someone from contacts
                </p>

            </div>

        </div>



        <!-- MESSAGES -->

        <div
            id="messages"
            class="messages">

            <div class="welcome-message">

                <div class="welcome-icon">
                    💬
                </div>

                <h2>
                    Welcome to Simple Chat
                </h2>

                <p>
                    Select a person from the contacts
                    to start chatting.
                </p>

            </div>

        </div>



        <!-- MESSAGE BOX -->

        <div class="message-area">

            <form id="messageForm">

                <input
                    type="text"
                    id="messageInput"
                    placeholder="Select a person to chat..."
                    autocomplete="off"
                    disabled>

                <button
                    type="submit"
                    id="sendButton"
                    disabled>

                    ➤

                </button>

            </form>

        </div>


    </main>

</div>



<script>

    // ============================================
    // CURRENT USER
    // ============================================

    const currentUser = "<%= username %>";

    let selectedUser = null;



    // ============================================
    // LOAD USERS
    // ============================================

    function loadUsers() {

        fetch("ChatEndpoint?action=users")

            .then(function(response) {

                if (!response.ok) {
                    throw new Error("Unable to load users");
                }

                return response.json();

            })

            .then(function(users) {

                const usersList =
                    document.getElementById("usersList");

                usersList.innerHTML = "";


                if (users.length === 0) {

                    const empty =
                        document.createElement("div");

                    empty.className = "loading";

                    empty.textContent =
                        "No other users yet.";

                    usersList.appendChild(empty);

                    return;
                }


                users.forEach(function(user) {

                    createUserElement(
                        usersList,
                        user
                    );

                });

            })

            .catch(function(error) {

                console.error(
                    "Users error:",
                    error
                );

                const usersList =
                    document.getElementById("usersList");

                usersList.innerHTML = "";

                const errorDiv =
                    document.createElement("div");

                errorDiv.className = "loading";

                errorDiv.textContent =
                    "Unable to load users.";

                usersList.appendChild(errorDiv);

            });

    }



    // ============================================
    // CREATE USER ELEMENT
    // ============================================

    function createUserElement(
        container,
        user
    ) {

        const item =
            document.createElement("div");

        item.className = "contact";

        item.onclick = function() {

            selectUser(user);

        };


        const avatar =
            document.createElement("div");

        avatar.className =
            "contact-avatar";

        avatar.textContent =
            user.charAt(0).toUpperCase();


        const details =
            document.createElement("div");

        details.className =
            "contact-details";


        const name =
            document.createElement("strong");

        name.textContent =
            user;


        const status =
            document.createElement("span");

        status.textContent =
            "● Available";


        details.appendChild(name);
        details.appendChild(status);


        item.appendChild(avatar);
        item.appendChild(details);


        container.appendChild(item);

    }



    // ============================================
    // SELECT USER
    // ============================================

    function selectUser(user) {

        selectedUser = user;


        // Remove active state

        const contacts =
            document.querySelectorAll(
                ".contact"
            );


        contacts.forEach(function(contact) {

            contact.classList.remove(
                "selected"
            );

        });


        // Find selected contact

        contacts.forEach(function(contact) {

            const name =
                contact.querySelector(
                    "strong"
                );

            if (
                name &&
                name.textContent === user
            ) {

                contact.classList.add(
                    "selected"
                );

            }

        });


        // Header

        document.getElementById(
            "chatUser"
        ).textContent = user;


        document.getElementById(
            "chatStatus"
        ).textContent =
            "Available to chat";


        document.getElementById(
            "headerAvatar"
        ).textContent =
            user.charAt(0).toUpperCase();


        // Enable input

        document.getElementById(
            "messageInput"
        ).disabled = false;


        document.getElementById(
            "sendButton"
        ).disabled = false;


        document.getElementById(
            "messageInput"
        ).placeholder =
            "Type your message...";


        // Load messages

        loadMessages();

    }



    // ============================================
    // LOAD MESSAGES
    // ============================================

    function loadMessages() {

        if (selectedUser === null) {
            return;
        }


        const url =
            "ChatEndpoint?action=messages&receiver="
            + encodeURIComponent(selectedUser);


        fetch(url)

            .then(function(response) {

                if (!response.ok) {
                    throw new Error(
                        "Unable to load messages"
                    );
                }

                return response.json();

            })

            .then(function(messages) {

                const messagesDiv =
                    document.getElementById(
                        "messages"
                    );


                messagesDiv.innerHTML = "";


                if (messages.length === 0) {

                    const empty =
                        document.createElement("div");

                    empty.className =
                        "welcome-message";


                    const icon =
                        document.createElement("div");

                    icon.className =
                        "welcome-icon";

                    icon.textContent =
                        "💬";


                    const title =
                        document.createElement("h2");

                    title.textContent =
                        "No messages yet";


                    const text =
                        document.createElement("p");

                    text.textContent =
                        "Send the first message to "
                        + selectedUser
                        + ".";


                    empty.appendChild(icon);
                    empty.appendChild(title);
                    empty.appendChild(text);


                    messagesDiv.appendChild(empty);

                    return;

                }


                messages.forEach(function(msg) {

                    createMessage(
                        messagesDiv,
                        msg
                    );

                });


                messagesDiv.scrollTop =
                    messagesDiv.scrollHeight;

            })

            .catch(function(error) {

                console.error(
                    "Messages error:",
                    error
                );

            });

    }



    // ============================================
    // CREATE MESSAGE
    // ============================================

    function createMessage(
        container,
        msg
    ) {

        const row =
            document.createElement("div");


        if (
            msg.sender === currentUser
        ) {

            row.className =
                "message-row sent";

        } else {

            row.className =
                "message-row received";

        }


        const box =
            document.createElement("div");

        box.className =
            "message-box";


        const sender =
            document.createElement("div");

        sender.className =
            "message-sender";

        sender.textContent =
            msg.sender;


        const text =
            document.createElement("div");

        text.className =
            "message-text";

        text.textContent =
            msg.message;


        const time =
            document.createElement("span");

        time.className =
            "message-time";

        time.textContent =
            msg.time;


        box.appendChild(sender);
        box.appendChild(text);
        box.appendChild(time);


        row.appendChild(box);


        container.appendChild(row);

    }



    // ============================================
    // SEND MESSAGE
    // ============================================

    document
        .getElementById("messageForm")
        .addEventListener(
            "submit",
            function(event) {

                event.preventDefault();


                if (selectedUser === null) {
                    return;
                }


                const input =
                    document.getElementById(
                        "messageInput"
                    );


                const message =
                    input.value.trim();


                if (message === "") {
                    return;
                }


                const data =
                    new URLSearchParams();


                data.append(
                    "receiver",
                    selectedUser
                );


                data.append(
                    "message",
                    message
                );


                fetch(
                    "ChatEndpoint",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/x-www-form-urlencoded"
                        },

                        body: data
                    }
                )

                .then(function(response) {

                    if (!response.ok) {
                        throw new Error(
                            "Unable to send message"
                        );
                    }

                    return response.json();

                })

                .then(function(result) {

                    if (
                        result.status ===
                        "success"
                    ) {

                        input.value = "";

                        loadMessages();

                    }

                })

                .catch(function(error) {

                    console.error(
                        "Send error:",
                        error
                    );

                    alert(
                        "Message could not be sent."
                    );

                });

            }
        );



    // ============================================
    // ENTER KEY
    // ============================================

    document
        .getElementById("messageInput")
        .addEventListener(
            "keydown",
            function(event) {

                if (
                    event.key === "Enter"
                ) {

                    event.preventDefault();

                    document
                        .getElementById(
                            "messageForm"
                        )
                        .requestSubmit();

                }

            }
        );



    // ============================================
    // LOGOUT
    // ============================================

    function logout() {

        window.location.href =
            "LogoutServlet";

    }



    // ============================================
    // AUTO REFRESH
    // ============================================

    setInterval(
        function() {

            loadUsers();

            if (selectedUser !== null) {
                loadMessages();
            }

        },
        3000
    );



    // ============================================
    // INITIAL LOAD
    // ============================================

    loadUsers();

</script>


</body>

</html>