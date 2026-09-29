<form action="<%= request.getContextPath() %>/StartChat"
      method="post">

    <label for="username">
        Username
    </label>

    <input
        type="text"
        id="username"
        name="username"
        placeholder="Enter your username"
        maxlength="100"
        autocomplete="off"
        required>

    <button type="submit">
        Enter Chat →
    </button>

</form>