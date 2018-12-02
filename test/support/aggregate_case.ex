defmodule Commissionate.AggregateCase do
  @moduledoc """
  This module defines the test case to be used by aggregate tests.
  """

  use ExUnit.CaseTemplate

  using aggregate: aggregate do
    quote bind_quoted: [aggregate: aggregate] do
      @aggregate_module aggregate

      import Commissionate.Storage

      defp assert_events(commands, expected_events) do
        assert execute(List.wrap(commands)) == expected_events
      end

      defp assert_events(initial_events, commands, expected_events) do
        {_aggregate, events, error} =
          %@aggregate_module{}
          |> evolve(initial_events)
          |> execute(commands)

        actual_events = List.wrap(events)

        assert is_nil(error)
        assert expected_events == actual_events
      end

      defp execute(commands) do
        {_, events} =
          Enum.reduce(commands, {%@aggregate_module{}, []}, fn command, {aggregate, _} ->
            events = @aggregate_module.execute(aggregate, command)

            {evolve(aggregate, events), events}
          end)

        List.wrap(events)
      end

      defp execute(aggregate, commands) do
        commands
        |> List.wrap()
        |> Enum.reduce({aggregate, [], nil}, fn
          command, {aggregate, _events, nil} ->
            case @aggregate_module.execute(aggregate, command) do
              {:error, reason} = error -> {aggregate, nil, error}
              events -> {evolve(aggregate, events), events, nil}
            end

          _command, {aggregate, _events, _error} = reply ->
            reply
        end)
      end

      defp evolve(aggregate, events) do
        events
        |> List.wrap()
        |> Enum.reduce(aggregate, &@aggregate_module.apply(&2, &1))
      end
    end
  end
end
