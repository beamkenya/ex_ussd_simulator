defmodule ExUssdSimulator.Config do
  def callback_url, do: get_env!(:callback_url)
  def service_code, do: get_env(:service_code) || "*123#"

  defp get_env!(key) do
    get_env(key) || raise "You must set the :ex_ussd_simulator, #{key} environment variable"
  end

  defp get_env(key) do
    Application.get_env(:ex_ussd_simulator, key)
  end
end
