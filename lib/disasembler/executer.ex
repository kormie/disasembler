defmodule Disasembler.Executer do
  def run(file_name) do
    absfile = Path.absname(file_name)
    rootname = Path.rootname(absfile)

    erl_data =
      file_name
      |> extract_code
      |> extract_abstract
      |> :beam_lib.chunks([:abstract_code])
      |> get_abstract
      |> get_erl

    decompiled_filename = List.to_string([rootname, ".erl"])
    File.write(decompiled_filename, erl_data)
    {erl_data, decompiled_filename}
  end

  defp get_erl(abstract) do
    abstract
    |> :erl_syntax.form_list()
    |> :erl_prettypr.format()
  end

  defp get_abstract({:ok, {_, [{:abstract_code, {_, ac}}]}}), do: ac

  defp extract_code(file_name) do
    file_name
    |> File.read()
    |> Tuple.to_list()
    |> List.last()
  end

  defp extract_abstract(code_string) do
    code_string
    |> Code.compile_string()
    |> List.first()
    |> Tuple.to_list()
    |> List.last()
  end
end
