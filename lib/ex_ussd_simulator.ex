defmodule ExUssdSimulator do

    use Agent

    @doc """
    ### Example
        children = [
            {ExUssdSimulator, menu: ExUssd.Menu.render(name: "Home", handler: MyHomeHandler)}
        ]
    """
    def start_link(opts) do
        menu =
          opts[:menu] ||
            raise ArgumentError, "the :menu option is required by #{inspect(__MODULE__)}"

        Agent.start_link(fn -> opts end, name: __MODULE__)
      end
    
      def init(opts) do
        _name =
          opts[:menu] ||
            raise ArgumentError, "the :menu option is a required by #{inspect(__MODULE__)}.init/1"
    
        opts
      end
      
      def value do
        Agent.get(__MODULE__, & &1)
      end
    
end