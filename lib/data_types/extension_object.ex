defmodule ExOpcua.DataTypes.ExtensionObject do
  @moduledoc """
  	Defines the structure template and decodings/encodings for
  	the OPCUA Signed Software Certificate Parameter Type
    https://reference.opcfoundation.org/v104/Core/DataTypes/SignedSoftwareCertificate/
  """
  import ExOpcua.DataTypes.BuiltInDataTypes.Macros
  alias ExOpcua.DataTypes.{NodeId, ServerStatus}
  # defstruct [:encoding_mask, :namespace_idx, :identifier]

  @data_types %{
    864 => ServerStatus
  }
  # @type t :: %__MODULE__{
  #         encoding_mask: byte(),
  #         namespace_idx: integer(),
  #         identifier: any()
  #       }
  # @spec take(binary()) :: {__MODULE__.t(), binary()}
  def take(<<opc_null_value(), rest::binary>>) do
    {nil, rest}
  end

  def take(bin) do
    with {node, <<encoding_mask, rest::binary>>} <- NodeId.take(bin) do
      <<size::int(32), data::binary-size(size), rest::binary>> = rest

      value =
        case encoding_mask do
          0 ->
            :not_implemented

          1 ->
            case Map.get(@data_types, node.identifier) do
              nil ->
                :not_implemented

              data_type ->
                {value, _} = data_type.take(data)
                value
            end
        end

      {value, rest}
    end
  end
end
