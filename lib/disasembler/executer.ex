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
    :erl_prettypr.format(:erl_syntax.form_list(abstract))
  end

  defp get_abstract(beam_chunks) do
    {:ok, {_, [{:abstract_code, {_, ac}}]}} = beam_chunks
    ac
  end

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
