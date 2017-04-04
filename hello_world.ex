defmodule TestModule do
  def print_text("Hello World") do
    IO.puts "no"
  end

  def print_text([:skip, text]) do
    IO.puts "skipping #{text}"
  end

  def print_text(text) do
	  IO.puts text
  end
end

TestModule.print_text("A")
TestModule.print_text([:skip, "some skipped text"])
TestModule.print_text("Hello World")
