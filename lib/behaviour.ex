defmodule Parser do
  @callback parse(String.t()) :: {:ok, term} | {:error, String.t()}
  @callback extensions() :: [String.t()]
end

defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  # ... parse JSON
  def parse(str), do: {:ok, "some json " <> str}

  @impl Parser
  def extensions, do: ["json"]
end

defmodule YAMLParser do
  @behaviour Parser

  @impl Parser
  # ... parse YAML
  def parse(str), do: {:ok, "some yaml " <> str}

  @impl Parser
  def extensions, do: ["yml"]
end
