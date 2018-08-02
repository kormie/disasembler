defmodule Disasembler.Cli do
  def main(argv) do
    argv
    |> parse_args
    |> run
  end

  defp parse_args(args) do
    parsed_args =
      OptionParser.parse(
        args,
        switches: [help: :boolean, verbose: :boolean],
        aliases: [h: :help, v: :verbose]
      )

    case parsed_args do
      {[help: true], _, _} -> :help
      {[file: file_name, verbose: verbose], _, _} -> {:start, file_name, verbose}
      {[file: file_name], _, _} -> {:start, file_name, false}
      _ -> :help
    end
  end

  defp run(:help) do
    Bunt.puts([
      :color67_background,
      "\nCompile an Elixir module and decompile the beam code into erlang"
    ])

    Bunt.puts([
      :khaki,
      """

        Options:

      """,
      :olive,
      """
           --file file_name // File you wish to decompile

           --verbose // Show the Erlang output in the console
      """
    ])
  end

  defp run({:start, file_name, verbose}) do
    Bunt.puts([:steelblue, "Decompiling file…\n"])

    {erl_data, decompiled_file_name} = Disasembler.Executer.run(file_name)

    Bunt.puts([:steelblue, "Decompiled to: ", decompiled_file_name])

    if(verbose, do: Bunt.puts(["\n", :olive, erl_data]))
  end
end
