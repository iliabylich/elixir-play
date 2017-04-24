defmodule Point do
  @doc """
  Simple point struct

  ## Examples

      iex> %Point{}
      %Point{ x: 0, y: 0 }

      iex> %Point{ x: 100 }
      %Point{ x: 100, y: 0 }
      iex> %Point{ y: 200 }
      %Point{ x: 0, y: 200 }
      iex> %Point{ x: 5, y: 10 }
      %Point{ x: 5, y: 10 }

      iex> %Point{ x: 100 }.x
      100
  """
  defstruct x: 0, y: 0
end

defmodule Profile do
  defstruct first_name: "", last_name: ""

  @doc """
  Builds a full name of the user.

  ## Examples

      iex> Profile.full_name(%Profile{ first_name: "John", last_name: "Smith" })
      { :ok, "John Smith" }
      iex> Profile.full_name(%Profile{ first_name: nil, last_name: "Smith" })
      { :error, "Profile must have a first_name"}
      iex> Profile.full_name(%Profile{ first_name: "John", last_name: nil })
      { :error, "Profile must have a last_name"}
  """
  def full_name(%Profile{first_name: nil}), do: { :error, "Profile must have a first_name" }
  def full_name(%Profile{last_name: nil}), do: { :error, "Profile must have a last_name" }
  def full_name(%Profile{first_name: first_name, last_name: last_name}), do: { :ok, "#{first_name} #{last_name}" }
end

defmodule User do
  @doc """
      iex> %User{ email: "test@example.com" }.email
      "test@example.com"
      iex> %User{}.profile.first_name
      ""
      iex> %User{}.profile.last_name
      ""
  """
  defstruct profile: %Profile{}, email: ""

  @doc """
      iex> User.full_info %User{ profile: %Profile{ first_name: "F", last_name: "L" }, email: "E" }
      { :ok, "F L (E)" }
      iex> User.full_info %User{ profile: nil, email: "E" }
      { :error, "User must have a profile" }
  """
  def full_info(%User{ profile: nil }), do: { :error, "User must have a profile" }
  def full_info(%User{ email: nil }), do: { :error, "User must have a email" }
  def full_info(%User{ profile: profile, email: email }) do
    { :ok, full_name } = Profile.full_name(profile)
    { :ok, "#{full_name} (#{email})" }
  end
end
